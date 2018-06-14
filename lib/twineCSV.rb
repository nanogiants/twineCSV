require "twineCSV/version"
require 'rubygems'
require 'rubyXL'

module TwineCSV

  def self.to_csv input, output
    abort("The input file must not be nil") if input.nil? or output.nil?
    content = File.open(input, 'r').read
    lines = content.each_line.to_a.map {|line|
      result = line.gsub("\n", '').strip
      result[-1] == ";" ? result[0..-2] : result
    }
    dictionary = {}
    langs = []
    current_key = ''
    current_section = ''

    lines.reject {|line| line.length == 0}.each {|line|
      if line.start_with? '[['
        current_section = line[2..-3]
        puts current_section
        dictionary[current_section] = {}
      elsif line.start_with? '['
        current_key = line[1..-2]
        dictionary[current_section][current_key] = {}
      elsif current_key.length > 0
        lang, value = line.split("=", 2).map(&:strip)
        langs << lang
        dictionary[current_section][current_key][lang] = value || ''
      end
    }

    File.open(output, 'wb+') {|f|

      f << 'section;key;' << langs.uniq.join(';') << "\n"

      dictionary.each {|k, v|
        v.each {|k2, v2|
          vlangs = langs.uniq.map {|lang| v2[lang]}
          f << "#{k};#{k2};#{vlangs.join(";")}" << "\n"
        }
      }
    }

  end

  def self.to_twine input, output
    abort("The input file must not be nil") if input.nil? or output.nil?
    extension = input.split('.')[-1]

    if extension == 'csv'
      check_for_separator(input)

      content = File.open(input, 'r').read
      lines = content.each_line.to_a.map {|line| line.gsub("\n", '').strip}
      current_section = ''
      result = []
      langs = lines[0].split(';')[2..-1]

      lines[1..-1].each {|line|
        values = "#{line} ".split(";")
        old_section = current_section
        current_section = values.first

        if current_section != old_section
          result << "#{result.empty? ? '' : "\n"}[[#{current_section}]]"
          result << "  [#{values[1]}]" << values[2..-1].map.with_index {|value, i| "    #{langs[i].downcase} = #{value.strip}" unless langs[i].nil?}
        else
          result << "\n  [#{values[1]}]" << values[2..-1].map.with_index {|value, i| "    #{langs[i].downcase} = #{value.strip}" unless langs[i].nil?}
        end
      }

      File.open(output, 'wb+') {|f|
        f << result.join("\n")
      }
    elsif extension == 'xlsx'
      workbook = RubyXL::Parser.parse input

      worksheet = workbook[0]
      langs = []
      result = []

      current_section = ''
      worksheet.each_with_index {|row, row_index|
        row && row.cells.each_with_index {|cell, cell_index|
          if cell_index > 1
            if row_index == 0
              langs << cell&.value
            else
              result << "    #{langs[cell_index-2]} = #{cell&.value.strip}#{"\n" if cell_index - 2 >= langs.length-1}"
            end
          elsif cell_index == 1
            result << "  [#{cell&.value}]" unless row_index == 0
          elsif cell_index == 0
            old_section = current_section
            current_section = cell&.value

            result << "[[#{cell&.value}]]" unless row_index == 0 or old_section == current_section
          end
        }

        File.open(output, 'wb+') {|f|
          f << result.join("\n")
        }
      }
    else
      abort("The filetype #{extension} is currently not supported")
    end
  end

  def self.to_xlsx input, output
    abort("The input file must not be nil") if input.nil? or output.nil?
    content = File.open(input, 'r').read

    lines = content.each_line.to_a.map {|line|
      result = line.gsub("\n", '').strip
      result[-1] == ";" ? result[0..-2] : result
    }
    dictionary = {}
    langs = []
    current_key = ''
    current_section = ''

    lines.reject {|line| line.length == 0}.each {|line|
      if line.start_with? '[['
        current_section = line[2..-3]
        puts current_section
        dictionary[current_section] = {}
      elsif line.start_with? '['
        current_key = line[1..-2]
        dictionary[current_section][current_key] = {}
      elsif current_key.length > 0
        lang, value = line.split("=", 2).map(&:strip)
        langs << lang
        dictionary[current_section][current_key][lang] = value || ''
      end
    }

    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]
    worksheet.sheet_name = 'Translation'

    worksheet.add_cell 0, 0, 'Section'
    worksheet.add_cell 0, 1, 'Key'

    worksheet.change_column_width 0, 0
    worksheet.change_column_width 1, 0

    langs.uniq.each_with_index.map {|item, index|
      worksheet.add_cell 0, index + 2, item
      worksheet.change_column_width index + 2, 80
    }

    worksheet.change_row_border 0, :bottom, 'medium'
    worksheet.change_row_bold 0, true

    row = 1

    dictionary.each {|k, v|
      v.each {|k2, v2|
        vlangs = langs.uniq.map {|lang| v2[lang]}
        worksheet.add_cell row, 0, k
        worksheet.add_cell row, 1, k2

        vlangs.each_with_index {|item, column|
          cell = worksheet.add_cell row, column + 2, item
          cell.change_text_wrap true
          worksheet.change_row_fill row, 'cc3300' if item == ''
        }

        row += 1
      }
    }

    workbook.write output
  end

  def self.check_for_separator(input)
    allowed_separators = [';']

    content = File.open(input, 'r').read
    lines = content.each_line.to_a.map {|line| line.gsub("\n", '').strip}
    header_line = lines[0]

    unless header_line.nil?
      abort('No valid separator was found in the csv. Please use one of the following: ' + allowed_separators.join(' ')) unless allowed_separators.any? {|separator| header_line.include?(separator)}
    end
  end

end
