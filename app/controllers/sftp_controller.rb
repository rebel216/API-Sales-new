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
        @sftp_client.download!("/"+name, "tmp/storage"+name) 
        Item.delete_all
        Item.destroy_all
        
    end

    def list_files(remote_path,local_path)
        puts 'inside directory'
        @sftp_client.dir.foreach(remote_path) do |entry|
            puts"asdasgjdgajhksdgfkladgfldgafkasjdfgh;oqwefbwefvg"
            @file_date = entry.name.split('.')
            @file_date = @file_date[3]
            @year = Date.today.strftime('%y')
            @year = @year.slice(0,2)
            puts @year
            @date = Date.yesterday.strftime('%m%d'+@year)
            puts @file_date
            puts @date
            if @file_date == "121322"
                puts "equal"
                @item = Item.create(name:entry.name ,description:"/"+entry.name)
            end
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
