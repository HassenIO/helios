module CarsHelper

  CONVERTER = {0 => '0-50000 km', 50000 => '50000-100000 km', 100000 => '100000-150000 km', 150000 => '150000 km et plus'}

  def km_to_human(km)
    CONVERTER[km]
  end

  def km_to_list
    CONVERTER.collect {|k,v| [v,k]}
  end

end
