from pathlib import Path
import argparse
import random

import subprocess

def main(args=None):
    parser = argparse.ArgumentParser(description='Increment version number')
    parser.add_argument('file_path', type=Path, help='Path to the file containing version number')
    parser.add_argument('--bin_name', action='store_true', help='Generate the fw binary name only')
    cl_args = parser.parse_args(args)
    if not cl_args.file_path.exists():
        print(f"File {cl_args.file_path} does not exist")
        raise ValueError
    with cl_args.file_path.open('r') as f:
        major = 0
        minor = 0
        patch = 0

        major_ok = False
        minor_ok = False
        patch_ok = False

        new_minor = 0
        new_patch = 0

        for line in f:
            if "VERSION_MAJOR" in line:
                major = int(line.split(' ')[-1])
                major_ok = True
            if "VERSION_MINOR" in line:
                minor = int(line.split(' ')[-1])
                minor_ok = True 
            if "VERSION_PATCH" in line:
                patch = int(line.split(' ')[-1])
                patch_ok = True

    if not major_ok or not minor_ok or not patch_ok:
        raise ValueError(f"Could not find version number in file {major} {minor} {patch}")

    if cl_args.bin_name:
        print(f"supra-sru-fw_{major}_{minor}_{patch}.bin")
        return

    if minor < 200:
        new_minor = random.randint(200, 299)
    else:
        new_minor = minor

    new_patch = patch + 1

    branch_name = subprocess.run(['git', 'rev-parse', '--abbrev-ref', 'HEAD'], check=True, stdout=subprocess.PIPE).stdout.decode('utf-8').strip()

    version_text = f"""#ifndef VERSION_INFO_H
#define VERSION_INFO_H

#define VERSION_MAJOR {major}
#define VERSION_MINOR {new_minor}
#define VERSION_PATCH {new_patch}

#define VERSION_INFO_FREETEXT "{branch_name}"

#define VERSION_CANOPEN_MAJOR   1
#define VERSION_CANOPEN_MINOR   5
#define VERSION_CANOPEN_PATCH   0

#endif /* VERSION_INFO_H */"""

    with cl_args.file_path.open('w') as f:
        f.write(version_text)
    print(f"Version number updated to {major}.{new_minor}.{new_patch} on branch {branch_name}")


if __name__ == '__main__':
    main()
