class SftpController < ApplicationController
    def initialize(host, user, password)
        @host = host
        @user = user
        @password = password
    end

    def connect
        sftp_client.connect!
        rescue Net::SSH::RuntimeError
        puts "Failed to connect to #{@host}"
    end

    def disconnect
        sftp_client.close_channel
        ssh_session.close
    end

    def download_file(name)
        @sftp_client.download!("/"+name, "public/"+name) 
        # data = open("/Users/anomaly/api-pdf/Docs/"+name) 
        # @item = Item.create(name:name ,description:"/Docs/"+name,file:{url:"Docs/"+name})
        # render json:"data #{data.read}"
        # send_file "/Users/anomaly/api-pdf/Docs/"+name
        # data = File.open("/Users/anomaly/api-pdf/Docs/"+name)
        # view_file = Rails.root.join("/Docs/", name).to_s
        # render json: data.read
        
    end

    def list_files(remote_path,local_path)
        puts 'inside directory'
        @sftp_client.dir.foreach(remote_path) do |entry|
            puts entry.name
            @item = Item.create(name:entry.name ,description:"/"+entry.name)
        end
               
    end
    
    def remove_file(file_name)
    end

    def sftp_client
        @sftp_client ||= Net::SFTP::Session.new(ssh_session)
    end

    private

    def ssh_session
        @ssh_session ||= Net::SSH.start(@host, @user, @password)
    end

end
