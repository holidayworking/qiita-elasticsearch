require "qiita/elasticsearch/nodes/match_node"
require "qiita/elasticsearch/nodes/term_node"

module Qiita
  module Elasticsearch
    module Nodes
      class FilterNode
        # @param [Array<Qiita::Elasticsearch::Tokens>] tokens
        def initialize(tokens)
          @tokens = tokens
        end

        def to_hash
          if must_not_tokens.empty? && must_tokens.length == 1
            TermNode.new(must_tokens.first).to_hash
          else
            {
              "bool" => {
                "_cache" => true,
                "must" => must_queries,
                "must_not" => must_not_queries,
              }.reject do |key, value|
                value.is_a?(Array) && value.empty?
              end,
            }
          end
        end

        private

        def must_not_queries
          must_not_tokens.map do |token|
            if token.field_name.nil?
              {
                "query" => token.to_hash,
              }
            else
              TermNode.new(token).to_hash
            end
          end
        end

        def must_not_tokens
          @must_not_tokens ||= @tokens.select(&:must_not?)
        end

        def must_queries
          must_tokens.map do |token|
            TermNode.new(token).to_hash
          end
        end

        def must_tokens
          @must_tokens ||= @tokens.select(&:must?)
        end
      end
    end
  end
end
