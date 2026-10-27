module TrackerApi
  module Resources
    class FileAttachment
      include Shared::Base

      attribute :comment, Comment

      attribute :id, Types::Integer
      attribute :big_url, Types::String
      attribute :content_type, Types::String
      attribute :created_at, Types::DateTime
      attribute :download_url, Types::String
      attribute :filename, Types::String
      attribute :height, Types::Integer
      attribute :kind, Types::String
      attribute :size, Types::Integer
      attribute :thumbnail_url, Types::String
      attribute :thumbnailable, Types::Boolean
      attribute :uploaded, Types::Boolean
      attribute :uploader_id, Types::Integer
      attribute :width, Types::Integer

      def delete
        comment.delete_attachments([id])
      end

      # TODO : Implement download properly. 
      # Look at Attchment#download for more details
      # The big_url actually has the AWS S3 link for the file
      # def download
      #   file_data = Endpoints::Attachment.new(comment.client).download(download_url)
      #   File.open(filename, 'wb') { |fp| fp.write(file_data) }
      # end
    end
  end
end

