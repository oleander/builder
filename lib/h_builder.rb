# frozen_string_literal: true

require "dry/core/constants"
require "dry-initializer"
require "forwardable"
require "dry-types"

#:reek:IrresponsibleModule
module HBuilder
  include Dry::Core::Constants

  Error = Class.new(StandardError)

  class Abstract < BasicObject
    def self.const_missing(name)
      ::Object.const_get(name)
    end

    module Types
      include Dry::Types()
    end

    include Dry::Core::Constants
    extend Dry::Initializer
    extend Forwardable

    param :context, type: Types.Instance(Binding)
    param :result, type: Types.Constant(Undefined)
    param :block, type: Types.Instance(Proc)

    delegate receiver: :context

    class Array < self
      param :result, type: Types::Array

      def initialize(context, &block)
        super(EMPTY_ARRAY, context, &block)
      end

      def merge(method, value)
        Types::Array[result].append({ method => value })
      rescue Dry::Types::ConstraintError
        raise Error, "Cannot combine array with hash"
      end
    end

    class Hash < self
      param :result, type: Types::Hash

      def initialize(context, &block)
        super(EMPTY_HASH, context, &block)
      end

      def merge(method, value)
        Types::Hash[result].store(method, value)
      rescue Dry::Types::ConstraintError
        raise Error, "Cannot combine hash with array"
      end
    end

    def self.call(context, &block)
      new(context, &block).result
    end

    def initialize(init, context, &block)
      super(context, init.dup, block)
      instance_eval(&block)
    end

    private

    def new(&block)
      Hash.call(context, &block)
    end

    def array(&block)
      unless result.empty?
        raise Error, "Array cannot be combined with other calls"
      end

      @result = Abstract::Array.call(context, &block)
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    # :reek:ManualDispatch,
    # :reek:TooManyStatements
    def method_missing(method, *args, &block)
      super unless respond_to_missing?(method)

      if receiver.respond_to?(method, false)
        return receiver.public_send(method, *args, &block)
      end

      value = Undefined.default(args.fetch(0, Undefined)) do
        block ? new(&block) : Undefined
      end

      raise Error if value == Undefined
      raise Error if args.count > 1
      raise Error if args.any? && block

      merge(method, value)
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    # :reek:UtilityFunction
    def merge(*)
      raise NotImplementedError
    end

    def respond_to_missing?(method, *)
      !method.to_s.start_with?("__") || super
    end

    # :reek:UtilityFunction
    def raise(*args)
      Kernel.raise(*args)
    end
  end

  def self.call(context = binding, &block)
    Abstract::Hash.call(context, &block)
  end
end
