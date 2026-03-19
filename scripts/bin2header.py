#!/usr/bin/env python3
"""
Convert binary file to C header with embedded array.
Generates a header with the binary as uint32_t array in custom linker section.
"""

import argparse

def bytes_to_words(data):
    """Convert bytes to uint32_t words (little-endian)."""
    words = []
    for i in range(0, len(data), 4):
        # Read up to 4 bytes, pad with zeros if needed
        chunk = data[i:i+4]
        word = sum(byte << (8 * j) for j, byte in enumerate(chunk))
        words.append(f"0x{word:08X}")
    return words

def generate_header(binary_path, output_path, array_name, section_name, address):
    """Generate C header with binary array in custom section."""
    
    # Read binary file
    with open(binary_path, 'rb') as f:
        data = f.read()
    
    # Convert to words
    words = bytes_to_words(data)
    guard = f"__{array_name.upper()}_H__"
    
    # Write header file
    with open(output_path, 'w') as f:
        # Header guard and includes
        f.write(f"/* Auto-generated from {binary_path} ({len(data)} bytes) */\n")
        f.write(f"#ifndef {guard}\n")
        f.write(f"#define {guard}\n\n")
        f.write(f"#include <stdint.h>\n\n")
        
        # Binary array with section attribute
        f.write(f"/* Binary array in {section_name} section (target: {address}) */\n")
        f.write(f"const uint32_t {array_name}[] ")
        f.write(f"__attribute__((section(\"{section_name}\"), aligned(4), used)) = {{\n")
        
        # Write words (8 per line for readability)
        for i in range(0, len(words), 8):
            line = words[i:i+8]
            f.write("    " + ", ".join(line))
            f.write(",\n" if i + 8 < len(words) else "\n")
        
        f.write("};\n\n")
        f.write(f"#endif /* {guard} */\n")
    
    print(f"Generated: {output_path} ({len(data)} bytes = {len(words)} words)")

def main():
    parser = argparse.ArgumentParser(description='Convert binary to C header')
    parser.add_argument('binary', help='Input binary file')
    parser.add_argument('output', help='Output header file')
    parser.add_argument('--name', default='spatz_program', help='Array name')
    parser.add_argument('--section', default='.spatz_binary', help='Linker section name')
    parser.add_argument('--address', default='dynamic (_spatz_binary_start)', 
                       help='Target address (informational)')
    
    args = parser.parse_args()
    generate_header(args.binary, args.output, args.name, args.section, args.address)

if __name__ == '__main__':
    main()
