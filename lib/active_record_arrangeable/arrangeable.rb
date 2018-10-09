module ActiveRecord
  module Arrangeable
    def self.included(base)
      base.extend ArrangeClassMethods

      base.class_eval do
        ##
        # Adds custom arrange as scope
        #
        private_class_method def self.arrange_by(attr, arrange)
          scope "arrange_with_#{attr}", arrange
        end
      end

      return unless defined?(ActiveRecord::Relation)

      ActiveRecord::Relation.send :include, ArrangeClassMethods
    end

    module ArrangeClassMethods
      ##
      # Applies params sorts to current scope
      #
      def arrange(*args)
        ArrangeService.arrange(self, *args)
      end
    end
  end
end

