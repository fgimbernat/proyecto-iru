module Admin
  class SegmentationController < BaseController
    def index
      @segmentations = Segmentation.includes(:segmentation_items).all.order(:name)
    end

    # Crear nueva segmentación
    def create_segmentation
      @segmentation = Segmentation.new(segmentation_params)
      if @segmentation.save
        redirect_to admin_segmentation_path, notice: 'Segmentación creada exitosamente'
      else
        redirect_to admin_segmentation_path, alert: @segmentation.errors.full_messages.join(', ')
      end
    end

    # Actualizar segmentación
    def update_segmentation
      @segmentation = Segmentation.find(params[:id])
      if @segmentation.update(segmentation_params)
        redirect_to admin_segmentation_path, notice: 'Segmentación actualizada exitosamente'
      else
        redirect_to admin_segmentation_path, alert: @segmentation.errors.full_messages.join(', ')
      end
    end

    # Eliminar segmentación
    def destroy_segmentation
      @segmentation = Segmentation.find(params[:id])
      if @segmentation.destroy
        redirect_to admin_segmentation_path, notice: 'Segmentación eliminada exitosamente'
      else
        redirect_to admin_segmentation_path, alert: 'No se pudo eliminar la segmentación'
      end
    end

    # Crear item de segmentación
    def create_item
      @segmentation = Segmentation.find(params[:segmentation_id])
      @item = @segmentation.segmentation_items.new(item_params)
      if @item.save
        redirect_to admin_segmentation_path, notice: 'Item creado exitosamente'
      else
        redirect_to admin_segmentation_path, alert: @item.errors.full_messages.join(', ')
      end
    end

    # Actualizar item de segmentación
    def update_item
      @item = SegmentationItem.find(params[:id])
      if @item.update(item_params)
        redirect_to admin_segmentation_path, notice: 'Item actualizado exitosamente'
      else
        redirect_to admin_segmentation_path, alert: @item.errors.full_messages.join(', ')
      end
    end

    # Eliminar item de segmentación
    def destroy_item
      @item = SegmentationItem.find(params[:id])
      if @item.destroy
        redirect_to admin_segmentation_path, notice: 'Item eliminado exitosamente'
      else
        redirect_to admin_segmentation_path, alert: 'No se pudo eliminar el item'
      end
    end

    private

    def segmentation_params
      params.permit(:name, :visibility)
    end

    def item_params
      params.permit(:name)
    end
  end
end
