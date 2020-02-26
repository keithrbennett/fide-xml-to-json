#!/usr/bin/env ruby
#
# analyze_fide_data.rb


require 'awesome_print'
require 'json'
require 'set'

class FideAnalyzer

  attr_reader :records, :field_names

  def initialize(records)
    @records = records
    @field_names = find_field_names
  end


  def find_field_names
    fields = records.each_with_object(Set.new) do |record, fields|
      record.keys.each { |field_name| fields << field_name }
    end
    fields.sort
  end


  def rating_counts(records)
    rating_counts = { 0 => 0, 1 => 0, 2 => 0, 3 => 0 }
    records.each_with_object(rating_counts) do |r, rating_counts|
      rating_count = 0
      rating_count += 1 if r['rating']
      rating_count += 1 if r['rapid_rating']
      rating_count += 1 if r['blitz_rating']
      rating_counts[rating_count] += 1
    end
  end


  def call
    stats = {}
    stats['record_count'] = records.size
    stats['unique_id_count'] = records.count { |h| h['fideid'] }
    stats['std_rating_count']   = records.count { |h| h['rating'] }
    stats['blitz_rating_count'] = records.count { |h| h['blitz_rating'] }
    stats['rapid_rating_count'] = records.count { |h| h['rapid_rating'] }
    stats['rating_counts'] = rating_counts(records)
    stats['field_names'] = field_names
    stats['field_value_count'] = field_names.each_with_object({}) do |field_name, field_value_counts|
      value_count = records.count { |rec| rec[field_name] }
      field_value_counts[field_name] = value_count
    end

    stats['total_rating_count'] = stats['std_rating_count'] + stats['blitz_rating_count'] + stats['rapid_rating_count']
    stats
  end
end


class Runner

  JSON_FILESPEC_END_REGEX = /\.json$/i

  def validate_json_filespec(json_filespec)
    unless json_filespec                 \
          && File.file?(json_filespec)   \
          && JSON_FILESPEC_END_REGEX.match(json_filespec)
      puts "Error: Syntax is analyze_fide_data filename.json. Did you provide an existing filespec ending in .json?"
      exit(-1)
    end
  end


  def call
    json_filespec = ARGV[0]
    validate_json_filespec(json_filespec)
    print "Reading and parsing data..."
    records = JSON.parse(File.read(json_filespec))
    print "done.\nAnalyzing data..."
    stats = FideAnalyzer.new(records).call
    puts 'done.'

    stats_filespec = json_filespec[0..-6] + '-stats' + json_filespec[-5..-1] # preserve case
    File.write(stats_filespec, JSON.pretty_generate(stats))
    ap stats
  end
end


Runner.new.call
