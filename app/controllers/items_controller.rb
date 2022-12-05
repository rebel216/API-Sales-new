class ItemsController < ApplicationController
  before_action :set_item, only: %i[ index show update destroy ]

  # GET /items showing list of files at sftp heroku.
  def index
    @items = Item.all
    sftptogo_url = ''
    begin
      uri = URI.parse(sftptogo_url)
      rescue URI::InvalidURIError
      puts 'Bad SFTPTOGO_URL'
    end
    uri = URI.parse(''')
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
    sftptogo_url = '''
    begin
      uri = URI.parse(sftptogo_url)
      rescue URI::InvalidURIError
      puts 'Bad SFTPTOGO_URL'
    end
    uri = URI.parse('sftp:/'ogo.com')
    sftp = SftpController.new(uri.host, uri.user, password: uri.password)
    sftp.connect
    sftp.download_file(@item.name)
    
    sftp.disconnect 
    Item.delete_all
    render json: @item
  end

  # POST /items
  def create
    # @item = Item.new(item_params)
    # if @item.save
    #   params[:item][:document_data].each do |file|
    #     @item.documents.create!(:document => file)
    #   end
    #   render json: @item.file             
    # else
    #   render json: {user: @item.errors},status:unprocessable_entity        
    # end
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
    
    # @item = Item.find_by(id: params[:id])

    # # if item.file.attached?
    # redirect_to rails_blob_url(@item)
    # # else
      # head :not_found
    # end
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
