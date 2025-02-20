from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm
import re

print("adding ISO dates to listperson")
doc = TeiReader("data/indices/listperson.xml")

for x in tqdm(doc.any_xpath(".//tei:person//tei:birth")):
    match = re.search(r"\b\d{4}\b", x.text)
    year = match.group()
    x.attrib["notBefore"] = f"{year}-01-01"
    x.attrib["notAfter"] = f"{year}-12-31"
doc.tree_to_file("data/indices/listperson.xml")

for x in tqdm(doc.any_xpath(".//tei:person//tei:death")):
    match = re.search(r"\b\d{4}\b", x.text)
    year = match.group()
    x.attrib["notBefore"] = f"{year}-01-01"
    x.attrib["notAfter"] = f"{year}-12-31"
doc.tree_to_file("data/indices/listperson.xml")