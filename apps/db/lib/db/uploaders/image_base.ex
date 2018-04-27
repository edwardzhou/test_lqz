defmodule DB.Uploaders.ImageBase do
  defmacro __using__(_options) do
    quote do
      use Arc.Definition
      use Arc.Ecto.Definition

      # To add a thumbnail version:
      @versions [:original, :thumb]

      # Whitelist file extensions:
      def validate({file, _}) do
        ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
      end

      def filename(version, {file, _}) do
        "#{Path.basename(file.file_name, Path.extname(file.file_name))}_#{version}"
      end

      # Override the storage directory:
      def storage_dir(_version, {_file, _scope}) do
        "uploads/images"
      end

      # Provide a default URL if there hasn't been a file uploaded
      def default_url(_version, _scope) do
        # "priv/static/images/default_#{version}.png"
        "https://placehold.it/100x100"
      end

      # Specify custom headers for s3 objects
      # Available options are [:cache_control, :content_disposition,
      #    :content_encoding, :content_length, :content_type,
      #    :expect, :expires, :storage_class, :website_redirect_location]
      #
      # def s3_object_headers(version, {file, scope}) do
      #   [content_type: Plug.MIME.path(file.file_name)]
      # end
    end
  end
end
