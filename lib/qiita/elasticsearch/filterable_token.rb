require "qiita/elasticsearch/token"

module Qiita
  module Elasticsearch
    class FilterableToken < Token
      # @return [Hash]
      def to_hash
        {
          "term" => {
            @field_name => downcased_term,
          },
        }
      end
    end
  end
end