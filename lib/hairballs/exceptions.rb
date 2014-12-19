class Hairballs
  class PluginNotFound < RuntimeError
    def initialize(plugin_name)
      message = "Plugin not found: :#{plugin_name}."
      super(message)
    end
  end

  class PluginLoadFailure < RuntimeError
    def initialize(plugin_name)
      message = "Unable to load plugin: :#{plugin_name}."
      super(message)
    end
  end

  class ThemeUseFailure < RuntimeError
    def initialize(theme_name)
      message = "Theme not found: :#{theme_name}."
      super(message)
    end
  end
end
