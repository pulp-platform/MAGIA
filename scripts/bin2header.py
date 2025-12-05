#!/usr/bin/env python3
"""
Copyright (C) 2024 ETH Zurich and University of Bologna
Licensed under the Apache License, Version 2.0
SPDX-License-Identifier: Apache-2.0

Convert binary file to C header with array positioned at specific address.
The array will be placed in a custom section that can be positioned by linker.
"""

import sys
import argparse

def bin_to_c_source(bin_path, c_path, array_name, section_name, address):
    """
    Convert binary to C source file with array in custom section.
    
    Args:
        bin_path: Input binary file path
        c_path: Output C source file path
        array_name: Name of the C array
        section_name: Linker section name (e.g., ".spatz_code")
        address: Target address in hex (e.g., "0xCC040000")
    """
    # Read binary data
    with open(bin_path, 'rb') as f:
        data = f.read()
    
    size = len(data)
    
    # Generate C source file
    with open(c_path, 'w') as f:
        f.write(f"/* Auto-generated from {bin_path} */\n")
        f.write(f"/* Binary size: {size} bytes */\n")
        f.write(f"/* Target address: {address} */\n\n")
        f.write(f"#include <stdint.h>\n\n")
        
        # Array definition with section attribute and used attribute
        # The __attribute__((section(...))) places the array in custom section
        # The __attribute__((used)) prevents the linker from removing it
        # The linker script will position this section at the target address
        f.write(f"/* Array positioned in {section_name} section at {address} */\n")
        f.write(f"const uint32_t {array_name}[] __attribute__((section(\"{section_name}\"), aligned(4), used)) = {{\n")
        
        # Write data as uint32_t array (4 bytes per word)
        words = []
        for i in range(0, size, 4):
            if i + 4 <= size:
                # Full word (little-endian)
                word = (data[i] | (data[i+1] << 8) | 
                       (data[i+2] << 16) | (data[i+3] << 24))
                words.append(f"0x{word:08X}")
            else:
                # Partial word at end
                word = 0
                for j in range(i, size):
                    word |= data[j] << (8 * (j - i))
                words.append(f"0x{word:08X}")
        
        # Write 8 words per line
        for i in range(0, len(words), 8):
            line_words = words[i:i+8]
            f.write("    " + ", ".join(line_words))
            if i + 8 < len(words):
                f.write(",\n")
            else:
                f.write("\n")
        
        f.write(f"}};\n")
    
    print(f"✓ Generated C source: {c_path}")
    print(f"  - Array name: {array_name}")
    print(f"  - Section: {section_name}")
    print(f"  - Size: {size} bytes ({len(words)} words)")
    print(f"  - Target address: {address}")

def bin_to_header(bin_path, header_path, array_name, section_name, address):
    """
    Convert binary to C header with array in custom section.
    
    Args:
        bin_path: Input binary file path
        header_path: Output header file path
        array_name: Name of the C array
        section_name: Linker section name (e.g., ".spatz_code")
        address: Target address in hex (e.g., "0xCC040000")
    """
    # Read binary data
    with open(bin_path, 'rb') as f:
        data = f.read()
    
    size = len(data)
    
    # Generate header file
    with open(header_path, 'w') as f:
        f.write(f"/* Auto-generated from {bin_path} */\n")
        f.write(f"/* Binary size: {size} bytes */\n")
        f.write(f"/* Target address: {address} */\n\n")
        f.write(f"#ifndef __{array_name.upper()}_H__\n")
        f.write(f"#define __{array_name.upper()}_H__\n\n")
        f.write(f"#include <stdint.h>\n\n")
        
        # Array declaration with section attribute
        # The __attribute__((section(...))) places the array in custom section
        # The linker script will position this section at the target address
        f.write(f"/* Array positioned in {section_name} section */\n")
        f.write(f"/* Linker script must place {section_name} at {address} */\n")
        f.write(f"const uint32_t {array_name}[] __attribute__((section(\"{section_name}\"), aligned(4))) = {{\n")
        
        # Write data as uint32_t array (4 bytes per word)
        words = []
        for i in range(0, size, 4):
            if i + 4 <= size:
                # Full word (little-endian)
                word = (data[i] | (data[i+1] << 8) | 
                       (data[i+2] << 16) | (data[i+3] << 24))
                words.append(f"0x{word:08X}")
            else:
                # Partial word at end
                word = 0
                for j in range(i, size):
                    word |= data[j] << (8 * (j - i))
                words.append(f"0x{word:08X}")
        
        # Write 8 words per line
        for i in range(0, len(words), 8):
            line_words = words[i:i+8]
            f.write("    " + ", ".join(line_words))
            if i + 8 < len(words):
                f.write(",\n")
            else:
                f.write("\n")
        
        f.write(f"}};\n\n")
        
        # Metadata macros
        f.write(f"#define {array_name.upper()}_SIZE {size}\n")
        f.write(f"#define {array_name.upper()}_START ((uint32_t)&{array_name}[0])\n")
        f.write(f"#define {array_name.upper()}_END ((uint32_t)&{array_name}[{len(words)}])\n\n")
        
        f.write(f"#endif /* __{array_name.upper()}_H__ */\n")
    
    print(f"✓ Generated header: {header_path}")
    print(f"  - Array name: {array_name}")
    print(f"  - Section: {section_name}")
    print(f"  - Size: {size} bytes ({len(words)} words)")
    print(f"  - Target address: {address}")

def main():
    parser = argparse.ArgumentParser(
        description='Convert binary to C source/header with positioned array'
    )
    parser.add_argument('binary', help='Input binary file')
    parser.add_argument('output', help='Output C source or header file')
    parser.add_argument('--name', '-n', default='spatz_program',
                       help='Array name (default: spatz_program)')
    parser.add_argument('--section', '-s', default='.spatz_code',
                       help='Section name (default: .spatz_code)')
    parser.add_argument('--address', '-a', default='0xCC040000',
                       help='Target address (default: 0xCC040000)')
    parser.add_argument('--mode', '-m', default='header', choices=['source', 'header'],
                       help='Output mode: source (.c) or header (.h) (default: header)')
    
    args = parser.parse_args()
    
    if args.mode == 'source':
        bin_to_c_source(args.binary, args.output, args.name, args.section, args.address)
    else:
        bin_to_header(args.binary, args.output, args.name, args.section, args.address)
    return 0

if __name__ == '__main__':
    sys.exit(main())
