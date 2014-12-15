require_relative 'helpers'
require_relative 'prompt'

class Hairballs
  class Theme
    include Hairballs::Helpers

    attr_accessor :name
    attr_accessor :extend_bundler

    # @param name [Symbol]
    def initialize(name)
      @name = name
      @prompt = Prompt.new
    end

    def use!
      do_bundler_extending if @extend_bundler
      require_libraries
      @prompt_block.call(@prompt)
      IRB.conf[:PROMPT][irb_name] = @prompt.irb_configuration
      IRB.conf[:PROMPT_MODE] = irb_name
    end

    # @return [Symbol]
    def irb_name
      @name.to_s.upcase
    end

    # @return [Hairballs::Prompt]
    def prompt(&block)
      @prompt_block = block
    end

    #---------------------------------------------------------------------------
    # PRIVATES
    #---------------------------------------------------------------------------

    private

    # Add all gems in the global gemset to the $LOAD_PATH so they can be used even
    # in places like 'rails console'.
    def do_bundler_extending
      if defined?(::Bundler)
        all_global_gem_paths = Dir.glob("#{Gem.dir}/gems/*")

        all_global_gem_paths.each do |p|
          gem_path = "#{p}/lib"
          $:.unshift(gem_path)
        end
      else
        vputs 'Bundler not defined.  Skipping.'
      end
    end

    # Undo the stuff that was done in #do_bundler_extending.
    def undo_bundler_extending
      if defined?(::Bundler)
        all_global_gem_paths = Dir.glob("#{Gem.dir}/gems/*")

        all_global_gem_paths.each do |p|
          gem_path = "#{p}/lib"
          $:.delete(gem_path)
        end
      else
        vputs 'Bundler not defined.  Skipping.'
      end
    end
  end
end
