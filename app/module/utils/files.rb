module Utils
  class Files
    class << self
      def download_link(file_name, binary)
        return nil unless file_name && binary
        return raise ArgumentError, 'must supply a valid file_name' unless file_name.include?('.')

        folder_name = generate_folder_name
        FileUtils.mkdir_p(Rails.root.join("tmp/#{folder_name}"))
        File.open(Rails.root.join("tmp/#{folder_name}/#{file_name}"), 'w+b') { |f| f.write binary }
        url_helper = Rails.application.routes.url_helpers
        url_helper.download_documents_url(folder_name)
      end

      private

      def generate_folder_name
        hex = SecureRandom.hex(10)
        return hex unless File.directory?(Rails.root.join("tmp/#{hex}"))

        generate_folder_name
      end
    end
  end
end
