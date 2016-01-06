require "nokogiri"

module Embulk
  module Parser

    class XPathParserPlugin < ParserPlugin
      Plugin.register_parser("xpath", self)

      def self.transaction(config, &control)
        schema = config.param("schema", :array)
        schema_serialized = schema.inject({}) do |memo, s|
          memo[s["name"]] = s["type"]
          memo
        end
        task = {
          :schema => schema_serialized,
          :root => config.param("root", :string),
          :namespaces => config.param("namespaces", :hash)
        }
        columns = schema.each_with_index.map do |c, i|
          Column.new(i, c["name"], c["type"].to_sym)
        end
        yield(task, columns)
      end

      def run(file_input)
        on_new_record = lambda {|record|
          @page_builder.add(record)
        }
        doc = RecordBinder.new(@task["root"],
                               @task["schema"], @task["namespaces"], on_new_record)

        while file = file_input.next_file
          data = file.read
          if !data.nil? && !data.empty?
            doc.clear
            doc.parse(data)
          end
        end
        @page_builder.finish
      end
    end

    class RecordBinder 

      def initialize(root, schema, namespaces, on_new_record)
        @root = root
        @schema = schema
        @on_new_record = on_new_record
        @namespaces = namespaces
        clear
        super()
      end

      def clear
        @find_route_idx = 0
        @enter = false
        @current_element_name = nil
        @current_data = new_map_by_schema
      end

      def parse(data)
        doc = Nokogiri::XML(data)

        items = doc.xpath(@root, @namespaces)
        items.each do |item|
          @current_data = new_map_by_schema
         
          @schema.each do |key,value|
            doc.xpath(key, @namespaces).each do |item|
              @current_data[key] = item.text
            end
          end
          
          @on_new_record.call(@current_data.map{|k, v| v})
        end
      end

      def characters(string)
        return if !@enter || string.strip.size == 0 || @current_element_name.nil?
        val = @current_data[@current_element_name]
        val = "" if val.nil?
        val += string
        @current_data[@current_element_name] = val
      end

      private

      def new_map_by_schema
        @schema.keys.inject({}) do |memo, k|
          memo[k] = nil
          memo
        end
      end

      def convert(val, type)
        v = val.nil? ? "" : val
        case type
          when "string"
            v
          when "long"
            v.to_i
          when "double"
            v.to_f
          when "boolean"
            ["yes", "true", "1"].include?(v.downcase)
          when "timestamp"
            v.empty? ? nil : Time.strptime(v, c["format"])
          else
            raise "Unsupported type '#{type}'"
        end
      end
    end
  end
end
