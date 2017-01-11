require "twineCSV/version"
require 'rubygems'

module TwineCSV

  def self.to_csv input, output
    abort("The input file must not be nil") if input.nil? or output.nil?
    content = File.open(input, 'r').read
    lines = content.each_line.to_a.map { |line|
      result = line.gsub("\n", '').strip
      result[-1] == ";" ? result[0..-2] : result
    }
    dictionary = {}
    langs = []
    current_key = ''
    current_section = ''

    lines.reject { |line| line.length == 0 }.each { |line|
      if line.start_with? '[['
        current_section = line[2..-3]
        puts current_section
        dictionary[current_section] = {}
      elsif line.start_with? '['
        current_key = line[1..-2]
        dictionary[current_section][current_key] = {}
      elsif current_key.length > 0
        lang, value = line.split("=").map(&:strip)
        langs << lang
        dictionary[current_section][current_key][lang] = value || ''
      end
    }

    File.open(output, 'wb+') { |f|

      f << 'section;key;' << langs.uniq.join(';') << "\n"

      dictionary.each { |k, v|
        v.each { |k2, v2|
          vlangs = langs.uniq.map(&:downcase).map { |lang| v2[lang] }
          f << "#{k};#{k2};#{vlangs.join(";")}" << "\n"
        }
      }
    }

  end

  def self.to_twine input, output
    abort("The input file must not be nil") if input.nil? or output.nil?

    content = File.open(input, 'r').read
    lines = content.each_line.to_a.map { |line| line.gsub("\n", '').strip }
    current_section = ''
    result = []
    langs = lines[0].split(';')[2..-1]

    lines[1..-1].each { |line|
      values = "#{line} ".split(";")
      old_section = current_section
      current_section = values.first

      if current_section != old_section
        result << "#{result.empty? ? '' : "\n"}[[#{current_section}]]"
        result << "  [#{values[1]}]" << values[2..-1].map.with_index { |value, i| "    #{langs[i].downcase} = #{value.strip}" unless langs[i].nil? }
      else
        result << "\n  [#{values[1]}]" << values[2..-1].map.with_index { |value, i| "    #{langs[i].downcase} = #{value.strip}" unless langs[i].nil? }
      end
    }

    File.open(output, 'wb+') { |f|
      f << result.join("\n")
    }

  end

end
