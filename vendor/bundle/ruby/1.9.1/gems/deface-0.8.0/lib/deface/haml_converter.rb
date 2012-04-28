module Deface
  class HamlConverter < Haml::Engine
    def result
      Deface::Parser.undo_erb_markup! String.new(render)
    end

    def push_script(text, preserve_script, in_tag = false, preserve_tag = false,
                    escape_html = false, nuke_inner_whitespace = false)
      push_text "<%= #{text.strip} %>"

      if block_given?
        yield
        push_silent('end')
      end
    end

    def push_silent(text, can_suppress = false)
      push_text "<% #{text.strip} %>"
    end

    def parse_old_attributes(line)
      attributes_hash, rest, last_line = super(line)

      attributes_hash = deface_attributes(attributes_hash)

      return attributes_hash, rest, last_line
    end


    def parse_new_attributes(line)
      attributes, rest, last_line = super(line)

      attributes[1] = deface_attributes(attributes[1])

      return attributes, rest, last_line
    end

    private

      # coverts { attributes into deface compatibily attributes
      def deface_attributes(attrs)
        return if attrs.nil?
        attrs.gsub! /\{|\}/, ''
        attrs = attrs.split(',')

        if attrs.join.include? "=>"
          attrs.map!{|a| a.split("=>").map(&:strip) }
        else
          attrs.map!{|a| a.split(": ").map(&:strip) }
        end

        attrs.map! do |a|
          if a[1][0] != ?' && a[1][0] != ?"
            a[0] = %Q{"data-erb-#{a[0].gsub(/:|'|"/,'')}"}
            a[1] = %Q{"<%= #{a[1]} %>"}
          end

          a
        end

        attrs.map{ |a| a.join " => " }.join(', ')
      end

  end
end
