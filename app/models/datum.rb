# The input data for a machine learing trial.
class Datum < ActiveRecord::Base
  # The name of the data file.
  validates :file_name, :presence => true, :uniqueness => true, 
                        :length => 1..64, :format => { :with => /.arff$/ }

  def to_s
    file_name
  end
  
  # @return [Hash] full content of the data file.
  def content
    ArffParser.parse File.join(ConfigVar[:data_dir], file_name)
  end
  
end

# Parser for the ARFF file format.
class ArffParser
  # Parses one file.
  #
  # @param [String] filename name of the file.
  def self.parse(filename)
    lines = File.readlines filename 
    content_hash = {}
    content_hash[:attributes] = []
    content_hash[:data] = []
    
    lines.each_with_index do |line, index|
      # Removes comment.
      line = line.split ?%, 2
      next if line.empty?
      line = line[0]
      kvp = line.chomp.split(' ', 2).map(&:strip)
      if kvp.length >= 1
        key = kvp[0].downcase
        case key
        when '@relation'
          content_hash[:relation] = kvp[1].strip_quotes if kvp.length >= 2
        when '@attribute'
          if kvp.length >= 2
            name, type = kvp[1].split ' ', 2
            if /{(?<nominal_values>.+)}/ =~ type 
              type = nominal_values.split(',').map(&:strip).map(&:strip_quotes)
            end
            content_hash[:attributes] << { :name => name.strip_quotes, 
                                           :type => type }
          end
        when '@data'
          lines[(index + 1)..-1].each do |line|
            line = line.chomp.strip 
            next if line.empty? || line.start_with?('%')
            start_index = 0
            instance = []
            loop do
              break if start_index >= line.length
              matched_index = line.index /(?<!\\)['"]|,/, start_index
              if matched_index.nil?
                end_index = line.length
              elsif line[matched_index] == ','
                end_index = matched_index
              else
                start_index = matched_index
                close_quote_index = line.index /(?<!\\)['"]/, start_index + 1
                end_index = close_quote_index && close_quote_index + 1 || 
                            line.length
              end
              value = line[start_index...end_index].strip
              instance << value.strip_quotes unless value.empty?
              start_index = end_index + 1 
            end
            content_hash[:data] << instance
          end
          break          
        end
      end
    end
    content_hash
  end
end

class String
  def strip_quotes
    self.gsub(/\A['"]/, '').gsub /['"]\Z/, ''
  end
end  