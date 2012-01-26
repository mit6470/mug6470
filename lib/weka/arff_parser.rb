# Parser for the ARFF file format.
class ArffParser
  # Parses one file.
  #
  # @param [String] filename full path name of the file.
  # @return [Hash] features: array of features and their types. 
  #                relation: the name of the relation in the data.
  #                examples: array of examples.
  def self.parse_file(filename)
    begin
      lines = File.readlines filename 
      self.parse_lines lines
    rescue
      return {}
    end
  end
  
  # Parses the content string of a ARFF file.
  #
  # @param [String] content content string of a ARFF file.
  # @return [Hash] features: array of features and their types. 
  #                relation: the name of the relation in the data.
  #                examples: array of examples.
  def self.parse_string(content)
    self.parse_lines content.split('\n').map(&:strip)
  end
  
  # Parses the array of line strings in a ARFF file.
  #
  # @param [Array(String)] lines array of line strings. 
  # @return [Hash] features: array of features and their types. 
  #                relation: the name of the relation in the data.
  #                examples: array of examples. Each example is an array of 
  #                          feature values.
  def self.parse_lines(lines)
    content_hash = {}
    content_hash[:features] = []
    content_hash[:examples] = []
    
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
            content_hash[:features] << { :name => name.strip_quotes, 
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
            content_hash[:examples] << instance
          end
          break          
        end
      end
    end
    content_hash
  end
end

class String
  # Strips the beginning and ending single or double quotes of a string.
  def strip_quotes
    self.gsub(/\A['"]/, '').gsub /['"]\Z/, ''
  end
end