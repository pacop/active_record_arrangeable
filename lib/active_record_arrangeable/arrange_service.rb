module ActiveRecord
  module Arrangeable
    class ArrangeService
      VALID_DIRECTIONS = [:asc, :desc, :ASC, :DESC,
                          "asc", "desc", "ASC", "DESC"].freeze

      DEFAULT_DIRECTION = :asc

      def self.arrange(relation, *args)
        self.new(relation).arrange!(args)
      end

      def initialize(relation)
        @relation = is_a?(ActiveRecord::Relation) ? relation : relation.all
      end

      def arrange!(*args)
        preproces_args(args)

        args.each do |arg|
          if arg.is_a?(Hash)
            arg.each do |field, value|
              apply_arrange(field, value)
            end
          else
            apply_arrange(arg, DEFAULT_DIRECTION)
          end
        end

        @relation
      end

      private

      def apply_arrange(field, direction)
        return if field.nil? || field.empty?
        method_name  = "arrange_with_#{field}"

        @relation = if @relation.respond_to?(method_name)
                      @relation.public_send(method_name, direction)
                    else
                      @relation.order(field => direction)
                    end
      end

      def preproces_args(order_args)
        order_args.map! do |arg|
          @relation.sanitize_sql_for_order(arg)
        end
        order_args.flatten!

        validate_direction_args(order_args)
      end

      def validate_direction_args(args)
        args.each do |arg|
          next unless arg.is_a?(Hash)
          arg.each do |_key, value|
            unless VALID_DIRECTIONS.include?(value)
              raise ArgumentError,
                "Direction \"#{value}\" is invalid. Valid directions are: "\
                "#{VALID_DIRECTIONS.to_a.inspect}"
            end
          end
        end
      end
    end
    end
end
