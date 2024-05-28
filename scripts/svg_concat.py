import argparse
import xml.etree.ElementTree as ET
import re

def remove_xml_namespace(xml_str: str) -> str:
    xml_str = re.sub(r"ns[01]\:", "", xml_str)
    return xml_str

# Function to extract SVG content and dimensions from a file
def extract_svg_content_and_dimensions(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
        root = ET.fromstring(content)
        svg_element = root
        width = int(svg_element.attrib.get('width', '0').replace('px', ''))
        height = int(svg_element.attrib.get('height', '0').replace('px', ''))
        output = ET.tostring(svg_element, encoding='unicode')
        return remove_xml_namespace(output), width, height

# Concatenate SVG files vertically
def concatenate_svgs(input_files, output_file):
    svg_contents = []
    total_height = 0
    total_width = 0

    # Extract SVG content and dimensions for each input file
    for file in input_files:
        if file == output_file:
            continue

        svg_content, width, height = extract_svg_content_and_dimensions(file)
        svg_contents.append((svg_content, width, height))
        total_height += height
        total_width = max(total_width, width)

    # Set the vertical spacing between the SVGs
    spacing = 0

    # Create the new SVG content by stacking the SVGs vertically
    new_svg_content = f'<svg xmlns="http://www.w3.org/2000/svg" width="{total_width}" height="{total_height}">'
    current_height = 0

    for svg_content, width, height in svg_contents:
        new_svg_content += f'<g transform="translate(0,{current_height})">{svg_content}</g>'
        current_height += height + spacing

    new_svg_content += '</svg>'

    # Write the new SVG content to the output file
    with open(output_file, 'w') as output_file:
        output_file.write(new_svg_content)

# Create a CLI for the script
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Concatenate multiple SVG files vertically')
    parser.add_argument('-i', '--input', nargs='+', help='Input SVG files', required=True)
    parser.add_argument('-o', '--output', help='Output file', required=True)
    args = parser.parse_args()

    concatenate_svgs(args.input, args.output)