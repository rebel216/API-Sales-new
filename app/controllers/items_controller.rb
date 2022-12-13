class ItemsController < ApplicationController
  before_action :set_item, only: %i[ index show update destroy ]
  
  # GET /items showing list of files at sftp heroku.
  def index
    # @items.destroy   
    Item.delete_all
    @items = Item.all
    sftptogo_url = ENV['SFTPTOGO_URL']
    begin
      uri = URI.parse(sftptogo_url)
      rescue URI::InvalidURIError
      puts 'Bad SFTPTOGO_URL'
    end
    uri = URI.parse(sftptogo_url)
    sftp = SftpController.new(uri.host, uri.user, password: uri.password)
    sftp.connect
    # sftp.download_file('/', '/Docs/')
    sftp.list_files('/',Rails.root + 'public')
    # disconnect
    
    sftp.disconnect
    puts "askjdalisgjdkljhgadsfkagsdkjfgldsafgkldgafkjgdakfgsadf"
    @items.each do |i|
      puts i.created_at
      if i.created_at > Date.yesterday
        # @todayItems = @todayItems + i
        puts i
      end
    end
    
    render json: @items
     
  end

  # GET /items/1 #downloading file with id
  def show
    @item = Item.find(params[:id])
    sftptogo_url = ENV['SFTPTOGO_URL']
    
    
    begin
      uri = URI.parse(sftptogo_url)
      rescue URI::InvalidURIError
      puts 'Bad SFTPTOGO_URL'
    end
    uri = URI.parse(sftptogo_url)
    sftp = SftpController.new(uri.host, uri.user, password: uri.password)
    sftp.connect
    sftp.download_file(@item.name)
    sftp.disconnect
    @item.document.attach(io:File.open('tmp/storage'+@item.name),filename: @item.name ,content_type:'application/all')
    # @item.file = url_for(@item.document)
    file =Base64.encode64(File.read('tmp/storage'+@item.name))
    @item.file = file
    render json:@item 
   

    # RestClient.post( 'http://localhost:3000/items/',file:file )
  end

  # POST /items
  def create
        
  end
  


  # PATCH/PUT /items/1
  def update
    
  end

  # DELETE /items/1
  def destroy 
    # @items = Item.all
    # @item = Item.Fin(params[:id])
    @item.destroy   
    Item.delete_all
  end

  def download
    
    @item = Item.find_by(id: params[:id])

    if item.file.attached?
      render json:@item
    else
      head :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :description,:document)
    end
end
