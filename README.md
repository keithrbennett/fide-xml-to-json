# FIDE Chess Player Rating Information XML to JSON Converter

The script included in this repo can be used to generate JSON files from the XML files provided at https://ratings.fide.com/download_lists.phtml.


## Installation Instructions

Download or clone this repository.

This script is a Ruby script. It uses Ruby gems (libraries). Install the gems by running `bundle` in the project directory. (Ruby and these gems work best in Mac OS or Linux. Windows should work but may present challenges.)

If you are running on Mac OS or Linux, you can `chmod +x fide_xml_to_json.rb` so that you can invoke the script without preceding its filespec with `ruby`.

## Operating Instructions

Syntax is:

`ruby fide_xml_to_json.rb my_file.xml`

It will show its progress, and when it is finished parsing all the XML records will write the JSON representation of the parsed data to a file whose name is the same as the XML file, but with `.xml` changed to `.json`.


## Advanced Usage

Assuming one can write even simple Ruby code, customizing this script is easy. As examples, the following can easily be done:

* _field filtering_ - exclude some fields from the JSON output
* _record filtering_ - exclude records meeting specified criteria
* _statistical analysis_ - analysis of the parsed data

Since the entire data set is read into the `records` array in memory, you can use this script to manipulate or process the data in any way you like, maybe even bypassing the JSON output entirely.