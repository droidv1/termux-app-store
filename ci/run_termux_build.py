import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PACKAGES_DIR = ROOT / "packages"
TERMUX_BUILD = ROOT / "termux-build"

REQUIRED_VARS = [
    "TERMUX_PKG_NAME",
    "TERMUX_PKG_VERSION",
    "TERMUX_PKG_DESCRIPTION",
    "TERMUX_PKG_LICENSE",
]

BAD_VERSION_PATTERNS = re.compile(r"^(0|0\.0|dev|latest)$", re.IGNORECASE)


def run(cmd, pkg=None):
    label = f"[{pkg}]" if pkg else ""
    print(f"{label} $ {' '.join(cmd)}")
    subprocess.check_call(cmd, cwd=ROOT)


def read_build_vars(build_file: Path):
    vars_found = {}
    with build_file.open() as f:
        for line in f:
            for var in REQUIRED_VARS:
                if line.startswith(var + "="):
                    vars_found[var] = line.split("=", 1)[1].strip().strip('"')
    return vars_found


def validate_build_sh(pkg: str, build_file: Path):
    if build_file.stat().st_size == 0:
        raise RuntimeError("build.sh is empty")

    vars_found = read_build_vars(build_file)

    for var in REQUIRED_VARS:
        if var not in vars_found or not vars_found[var]:
            raise RuntimeError(f"Missing or empty {var}")

    version = vars_found["TERMUX_PKG_VERSION"]
    if BAD_VERSION_PATTERNS.match(version):
        raise RuntimeError(f"Invalid version value: {version}")


def main():
    if not TERMUX_BUILD.exists():
        print("❌ termux-build not found")
        sys.exit(1)

    run(["chmod", "+x", "termux-build"])

    if not PACKAGES_DIR.exists():
        print("❌ packages/ directory missing")
        sys.exit(1)

    failed = False

    for pkg_dir in sorted(PACKAGES_DIR.iterdir()):
        if not pkg_dir.is_dir():
            continue

        pkg = pkg_dir.name
        build_sh = pkg_dir / "build.sh"

        print(f"\n🔍 Validating package: {pkg}")

        try:
            if not build_sh.exists():
                raise RuntimeError("build.sh not found")

            validate_build_sh(pkg, build_sh)

            run(["./termux-build", "lint", pkg], pkg)
            run(["./termux-build", "explain", pkg], pkg)
            run(["./termux-build", "suggest", pkg], pkg)

            print(f"✅ {pkg} passed validation")

        except subprocess.CalledProcessError:
            print(f"❌ {pkg} failed: termux-build error")
            failed = True

        except Exception as e:
            print(f"❌ {pkg} failed: {e}")
            failed = True

    if failed:
        print("\n❌ One or more packages failed validation")
        sys.exit(1)

    print("\n🎉 All packages validated successfully")


if __name__ == "__main__":
    main()
