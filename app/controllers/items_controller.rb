class ItemsController < ApplicationController
  before_action :set_item, only: %i[ index show update destroy ]
  
  # GET /items showing list of files at sftp heroku.
  def index
    Item.delete_all
    Item.destroy_all
    @items = Item.all
    sftptogo_url = ENV['SFTPTOGO_URL']
    # sftptogo_url = 'sftp://9011651f745182e96b53087197a896:gxnkc74p9xowl3pibxp2czk7n8r51oamvss2r216@sparkling-water-50295.sftptogo.com'
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
    
    render json: @items
     
  end

  # GET /items/1 #downloading file with id
  def show
    @item = Item.find(params[:id])
    sftptogo_url = ENV['SFTPTOGO_URL']
    # sftptogo_url = 'sftp://9011651f745182e96b53087197a896:gxnkc74p9xowl3pibxp2czk7n8r51oamvss2r216@sparkling-water-50295.sftptogo.com'
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
    
    
    render json:url_for(@item.document)
    
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
    # @item.destroy   
    # Item.delete_all
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
