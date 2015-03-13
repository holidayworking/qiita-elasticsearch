module Qiita
  module Elasticsearch
    class Token
      attr_reader :field_name, :term

      def initialize(field_name: nil, minus: nil, quoted: nil, term: nil, token_string: nil)
        @field_name = field_name
        @minus = minus
        @quoted = quoted
        @term = term
        @token_string = token_string
      end

      def must?
        !field_name.nil?
      end

      def must_not?
        negative?
      end

      # @return [true, false] True if this token is for negative filter
      # @note `Ruby -Perl`
      #             ^^^^^
      #             This
      def negative?
        !positive?
      end

      # @return [true, false] True if this token is for OR filter
      # @note `Ruby OR Perl`
      #             ^^
      #            This
      def or?
        @token_string.downcase == "or"
      end

      # @return [true, false] Opposite of #negative?
      def positive?
        @minus.nil?
      end

      # @return [true, false] True if this token is for phrase matching
      # @note `Express OR "Ruby on Rails"`
      #                   ^^^^^^^^^^^^^^^
      #                        This
      def quoted?
        !!@quoted
      end

      def should?
        !must? && !must_not?
      end

      # @note Override
      def to_s
        @token_string.dup
      end
    end
  end
end
