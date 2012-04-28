module Deface
  module Search
    module ClassMethods

      # finds all applicable overrides for supplied template
      #
      def find(details)
        return [] if self.all.empty? || details.empty?

        virtual_path = details[:virtual_path]
        return [] if virtual_path.nil?

        [/^\//, /\.\w+\z/].each { |regex| virtual_path.gsub!(regex, '') }

        result = []
        result << self.all[virtual_path.to_sym].try(:values)

        result.flatten.compact.sort_by &:sequence
      end
    end
  end
end
