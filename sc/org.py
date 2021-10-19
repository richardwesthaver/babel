#!/usr/bin/env python3
from orgparse import load
import os
import sys

def parse_org(org_path, html_path, output):
    "parse all org-mode documents from input directory, write file output"
    with open(output, "w") as output:
        output.write("// notes\nvec![\n")
        for entry in os.scandir(org_path):
            if entry.path.endswith(".org") and entry.is_file():
                print("parsing " + entry.path + " ...\n")
                root = load(entry.path)
                for node in root[1:]:
                    print("* {}".format(node.heading))
                    print(":ID: {}\n--++--\n".format(node.get_property('ID')))

                    sv_start = "vec!["
                    sv_end = "]"

                    if len(node.properties.keys()) == 1:
                        props = "vec![]"

                    elif len(node.properties.keys()) > 1:
                        for key, val in node.properties.items():
                            pairs = []
                            if key != 'ID':
                                pair = '("{}".to_string(),"{}".to_string())'.format(key, val)
                                pairs.append(pair)

                        props = sv_start + ",".join(pairs) + sv_end

                        

                    if len(node.tags) == 0:
                        tags = "vec![]"
                    else:
                        tags_start = 'vec!['
                        tags_end = ']'
                        tag_list = []
                        for t in node.tags:
                            tag = '"{}".to_string()'.format(t)
                            tag_list.append(tag)

                        tags = tags_start + ", ".join(tag_list) + tags_end

                    line = '  Org::new("{}", "{}", include_str!(concat!(env!("CARGO_MANIFEST_DIR"), "/../{}/{}")), {}, {}, {}),\n'.format(
                        node.get_property('ID').replace('-', ''),
                        node.heading.replace('"', ''),
                        html_path,
                        os.path.basename(node.env.filename).replace('.org', '.html'),
                        tags,
                        props,
                        node.level-1
                    )
                    output.write(line)
        output.write("]")

if __name__ == '__main__':
    parse_org("o/x/org", "o/x/html", "w/src/org/html.rs")
