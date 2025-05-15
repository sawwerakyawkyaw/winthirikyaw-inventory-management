# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AutoTrack.Repo.insert!(%AutoTrack.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias AutoTrack.Repo
alias AutoTrack.Inventory
alias AutoTrack.Inventory.Product

product_types_data = [
  %{name: "Air Filter", description: "Filters air entering the engine."},
  %{name: "Oil Filter", description: "Removes contaminants from engine oil."},
  %{name: "Fuel Filter", description: "Screens out dirt from fuel."},
  %{name: "Shock Bar", description: "Component of vehicle suspension system."},
  %{name: "Spring Coil", description: "Absorbs shock in vehicle suspension."},
  %{name: "Engine Mounting", description: "Secures engine and absorbs vibrations."},
  %{name: "Brake Pad", description: "Creates friction to stop vehicle wheels."},
  %{name: "Clutch Brake", description: "Assists in stopping clutch rotation."},
  %{name: "Clutch Cover", description: "Presses clutch disc against flywheel."},
  %{name: "Gasket", description: "Seals joints between two surfaces."},
  %{name: "Tie Rod", description: "Connects steering gear to steering knuckle."},
  %{name: "Rack End", description: "Connects tie rod to steering rack."}
]

# Prepare full data with image_urls
product_types_with_images =
  Enum.map(product_types_data, fn pt_attrs ->
    image_filename =
      pt_attrs.name
      |> String.downcase()
      |> String.replace(" ", "_")
      |> (&(&1 <> ".jpg")).()

    Map.put(pt_attrs, :image_url, "/images/product_type_images/#{image_filename}")
  end)

Enum.each(product_types_with_images, fn product_type_attrs ->
  case Inventory.get_product_type_by_name(product_type_attrs.name) do
    nil ->
      {:ok, _product_type} = Inventory.create_product_type(product_type_attrs)

      IO.puts(
        "Created product type: #{product_type_attrs.name} with image #{product_type_attrs.image_url}"
      )

    product_type ->
      # Update existing product types if descriptions or image_urls are different
      if product_type.description != product_type_attrs.description or
           product_type.image_url != product_type_attrs.image_url do
        {:ok, _updated_pt} = Inventory.update_product_type(product_type, product_type_attrs)
        IO.puts("Updated product type: #{product_type.name}")
      else
        IO.puts("Product type already exists with same details: #{product_type.name}")
      end
  end
end)

# Get product_type_id for "Air Filter"
air_filter_type = Inventory.get_product_type_by_name("Air Filter")

products_data = [
  %{
    oem_number: "17801-46080",
    sakura_number: "A-1173",
    car_name: "CROWN/ MARK II/ LEXUS (1998 - 2004)",
    brand: "BREATH",
    stock_qty: 2,
    buying_price: Decimal.new("10000"),
    selling_price: Decimal.new("14000")
  },
  %{
    oem_number: "ME-017242",
    sakura_number: "A-1039",
    car_name: "CANTER 4M51 (ပုံပြောင်း)",
    brand: "BRISCO",
    stock_qty: 2,
    buying_price: Decimal.new("15500"),
    selling_price: Decimal.new("21000")
  },
  %{
    oem_number: "17220-P2J-003",
    sakura_number: "A-1621",
    car_name: "HONDA CIVIC",
    brand: "BROWN",
    stock_qty: 2,
    buying_price: Decimal.new("10000"),
    selling_price: Decimal.new("14000")
  },
  %{
    oem_number: "16546-V0100",
    sakura_number: "A-1818",
    car_name: "NISSAN MARCH (1997) (သံ)",
    brand: "HANA",
    stock_qty: 5,
    buying_price: Decimal.new("10000"),
    selling_price: Decimal.new("14000")
  },
  %{
    oem_number: "17220-PWA-J10",
    sakura_number: "A-1661",
    car_name: "HONDA FIT GD1 - 2002 (စောင်း)",
    brand: "HANA",
    stock_qty: 10,
    buying_price: Decimal.new("10000"),
    selling_price: Decimal.new("14000")
  },
  %{
    oem_number: "17801-50060",
    sakura_number: "A-1190",
    car_name: "CROWN 3UZ/ LEXUS V8/ V6 (2001 - 2009)",
    brand: "HANA",
    stock_qty: 2,
    buying_price: Decimal.new("10000"),
    selling_price: Decimal.new("14000")
  },
  %{
    oem_number: "17801-56020",
    sakura_number: "A-3361, A-1119",
    car_name: "CROWN 3UZ/ LEXUS V8/ V6 (2001 - 2009)",
    brand: "HANA",
    stock_qty: 2,
    buying_price: Decimal.new("10000"),
    selling_price: Decimal.new("14000")
  },
  %{
    oem_number: "MR-404847",
    sakura_number: "A-1068",
    car_name: "PAJERO V73-78 (ဖားပြုတ် အပြား)",
    brand: "HANA",
    stock_qty: 3,
    buying_price: Decimal.new("10000"),
    selling_price: Decimal.new("14000")
  },
  %{
    oem_number: "17801-20040",
    sakura_number: "A-1189",
    car_name: "KULGER/ ALPHARD (3.0)",
    brand: "HBK",
    stock_qty: 2,
    buying_price: Decimal.new("10000"),
    selling_price: Decimal.new("14000")
  },
  %{
    oem_number: "16546-41B00",
    sakura_number: "A-1832",
    car_name: "NISSAN MARCH (1997) (သံ)",
    brand: "HK",
    stock_qty: 1,
    buying_price: Decimal.new("10000"),
    selling_price: Decimal.new("14000")
  },
  %{
    oem_number: "16546-89TA8",
    sakura_number: "A-6017",
    car_name: "NISSAN ATLAS/ ISUZU ELF (1999 -  2005)",
    brand: "HK",
    stock_qty: 5,
    buying_price: Decimal.new("10000"),
    selling_price: Decimal.new("14000")
  },
  %{
    oem_number: "16546-ED000/500",
    sakura_number: "A-1878",
    car_name: "AD VAN 1.5 (ရှည်) (သံ)",
    brand: "HK",
    stock_qty: 9,
    buying_price: Decimal.new("8695"),
    selling_price: Decimal.new("12000")
  },
  %{
    oem_number: "16546-KA160",
    sakura_number: "A-1879",
    car_name: "NISSAN MARCH (1997) (သံ)",
    brand: "HK",
    stock_qty: 2,
    buying_price: Decimal.new("10000"),
    selling_price: Decimal.new("14000")
  }
]

Enum.each(products_data, fn p ->
  attrs = %{
    oem_number: p.oem_number,
    car_name: p.car_name,
    brand: p.brand,
    stock_qty: p.stock_qty,
    buying_price: p.buying_price,
    selling_price: p.selling_price,
    product_type_id: air_filter_type.id,
    product_attributes: if p.sakura_number do
      [%{attribute_name: "SAKURA No.", attribute_value: p.sakura_number}]
    else
      []
    end
  }

  %Product{}
  |> Product.changeset(attrs)
  |> Repo.insert()
end)

oil_filter_type = Inventory.get_product_type_by_name("Oil Filter")

oil_products_data = [
  %{"oem" => "90915-30001", "sakura" => "C-1112", "car_name" => "1KZ", "brand" => "UNITRUCK", "qty" => 10, "buying" => "10000", "selling" => "13000"},
  %{"oem" => "15607-2120", "sakura" => "C-1321", "car_name" => "DYNA", "brand" => "UNITRUCK", "qty" => 5, "buying" => "13000", "selling" => "15000"},
  %{"oem" => "90915-3001", "sakura" => "C-1111", "car_name" => "2C/3C", "brand" => "UNITRUCK", "qty" => 4, "buying" => "9200", "selling" => "12000"},
  %{"oem" => "90915-3001", "sakura" => "C-1111", "car_name" => "2C/3C", "brand" => "SAKURA", "qty" => 1, "buying" => "9100", "selling" => "11800"},
  %{"oem" => "04152-31030", "sakura" => "EO-1102", "car_name" => "CROWN", "brand" => "UNITRUCK", "qty" => 19, "buying" => "5500", "selling" => "8000"},
  %{"oem" => "90915-10004", "sakura" => "C-1137", "car_name" => "PROBOX", "brand" => "UNITRUCK", "qty" => 25, "buying" => "4700", "selling" => "7000"},
  %{"oem" => "90915-10001", "sakura" => "C-1109 / C-1139", "car_name" => "HIJET", "brand" => "UNITRUCK", "qty" => 15, "buying" => "3400", "selling" => "5000"},
  %{"oem" => "90915-10001", "sakura" => "C-1109 / C-1139", "car_name" => "HIJET", "brand" => "SAKURA", "qty" => 4, "buying" => "3300", "selling" => "4800"},
  %{"oem" => "90915-10001", "sakura" => "C-1109 / C-1139", "car_name" => "HIJET", "brand" => "JET", "qty" => 1, "buying" => "3200", "selling" => "4700"},
  %{"oem" => "16510-82703", "sakura" => "C-1218", "car_name" => "SUZUKI (ခွေးဘီလူး)", "brand" => "UNITRUCK", "qty" => 10, "buying" => "4200", "selling" => "6200"},
  %{"oem" => "15208-31UOB", "sakura" => "C-1614", "car_name" => "HONDA", "brand" => "NISSAN", "qty" => 15, "buying" => "5600", "selling" => "7900"},
  %{"oem" => "15208-31U00", "sakura" => "C-1614", "car_name" => "HONDA", "brand" => "ZUREX", "qty" => 30, "buying" => "5200", "selling" => "7500"},
  %{"oem" => "15400-RTA-003", "sakura" => nil, "car_name" => "HONDA", "brand" => "HONDA", "qty" => 22, "buying" => "4800", "selling" => "7000"},
  %{"oem" => "909015-20001", "sakura" => "C-1142 / C-1149", "car_name" => "UNKNOWN", "brand" => "MASTER", "qty" => 4, "buying" => "4100", "selling" => "6300"},
  %{"oem" => "90915-YZZB1", "sakura" => "C-1119 / C-1160", "car_name" => "UNKNOWN", "brand" => "SAKURA", "qty" => 5, "buying" => "4500", "selling" => "6800"},
  %{"oem" => "90915-YZZB1", "sakura" => "C-1119 / C-1160", "car_name" => "UNKNOWN", "brand" => "MASTER", "qty" => 5, "buying" => "4400", "selling" => "6700"},
  %{"oem" => "90915-YZZD1", "sakura" => "C-1119 / C-1160", "car_name" => "UNKNOWN", "brand" => "TOYATA", "qty" => 2, "buying" => "4600", "selling" => "6900"},
  %{"oem" => "90915-YZZC5", "sakura" => "C-1132", "car_name" => "UNKNOWN", "brand" => "SAKURA", "qty" => 2, "buying" => "4300", "selling" => "6500"},
  %{"oem" => "ME-088532", "sakura" => "C-5808", "car_name" => "UNKNOWN", "brand" => "SAKURA", "qty" => 4, "buying" => "5500", "selling" => "7900"},
  %{"oem" => "90915-30002", "sakura" => "C-1112", "car_name" => "UNKNOWN", "brand" => "SAKURA", "qty" => 3, "buying" => "5000", "selling" => "7500"}
]

Enum.each(oil_products_data, fn p ->
  attrs = %{
    oem_number: p["oem"],
    car_name: p["car_name"] || "UNKNOWN",
    brand: p["brand"],
    stock_qty: p["qty"],
    buying_price: Decimal.new(p["buying"] || "5000"),
    selling_price: Decimal.new(p["selling"] || "7000"),
    product_type_id: oil_filter_type.id,
    product_attributes:
      if p["sakura"] do
        [%{attribute_name: "SAKURA No.", attribute_value: p["sakura"]}]
      else
        []
      end
  }

  %Product{}
  |> Product.changeset(attrs)
  |> Repo.insert()
end)

fuel_filter_type = Inventory.get_product_type_by_name("Fuel Filter")

fuel_products_data = [
  %{"oem" => "23300-B5010", "sakura" => "FS-7101", "car" => "HIJET (တို)", "brand" => "TOYOTA", "qty" => 8, "buying" => "8500", "selling" => "12000"},
  %{"oem" => "23300-B5010", "sakura" => "FS-7101", "car" => "HIJET (တို)", "brand" => "REIT", "qty" => 4, "buying" => "8000", "selling" => "11500"},
  %{"oem" => "2330-31140", "sakura" => "FS-7202", "car" => "CROWN (ကြီး)", "brand" => "TOYOTA", "qty" => 5, "buying" => "13500", "selling" => "18500"},
  %{"oem" => "2330-31140", "sakura" => "FS-7202", "car" => "CROWN (ကြီး)", "brand" => "HK", "qty" => 4, "buying" => "13000", "selling" => "18000"},
  %{"oem" => "2330-31140", "sakura" => "FS-7202", "car" => "CROWN (ကြီး)", "brand" => "ဖာညို", "qty" => 3, "buying" => "20300", "selling" => "25000"},
  %{"oem" => "17040-JR50A", "sakura" => "FS-7305", "car" => "AD VAN (1.3)", "brand" => "ဖာညို", "qty" => 4, "buying" => "17300", "selling" => "21000"},
  %{"oem" => "17040-ED800", "sakura" => "FS-7306", "car" => "AD VAN (1.5)", "brand" => "ဖာညို", "qty" => 3, "buying" => "16500", "selling" => "20000"},
  %{"oem" => "MR-431096", "sakura" => "FS-7401", "car" => "PAJERO IO, 4G63", "brand" => "HK", "qty" => 3, "buying" => "27181", "selling" => "32000"},
  %{"oem" => "43300-21010", "sakura" => "FS-7109", "car" => "MARK II, FIELDER", "brand" => "HK", "qty" => 3, "buying" => "14000", "selling" => "19000"},
  %{"oem" => "15310-76G00", "sakura" => "FS-7000", "car" => "UNKNOWN", "brand" => "HK", "qty" => 4, "buying" => "10000", "selling" => "14000"},
  %{"oem" => "23300-28040", "sakura" => "FS-7602", "car" => "KLUGER", "brand" => "ဖာညို", "qty" => 1, "buying" => "15500", "selling" => "19500"},
  %{"oem" => "FS-7304A", "sakura" => "FS-7304A", "car" => "HONDA FIT", "brand" => "JOJO", "qty" => 1, "buying" => "10500", "selling" => "15000"},
  %{"oem" => "16010-SAA-000", "sakura" => "FS-7308", "car" => "HONDA FIT", "brand" => "VK", "qty" => 2, "buying" => "11000", "selling" => "15500"},
  %{"oem" => "23300-23030", "sakura" => "FS-7502", "car" => "WISH", "brand" => "UNITRUCK", "qty" => 4, "buying" => "12000", "selling" => "16500"},
  %{"oem" => "23300-28030", "sakura" => "FS-1157", "car" => "ALPHARD", "brand" => "SAKURA", "qty" => 4, "buying" => "14200", "selling" => "19000"},
  %{"oem" => "23300-28030", "sakura" => "FS-1157", "car" => "ALPHARD", "brand" => "HK", "qty" => 1, "buying" => "13767", "selling" => "18500"},
  %{"oem" => "23300-21010", "sakura" => "FS-1149", "car" => "MARK II - ရွှေငါး", "brand" => "SAKURA", "qty" => 2, "buying" => "15179", "selling" => "20000"},
  %{"oem" => "23300-97501", "sakura" => "FS-7108", "car" => "HIJET (ရှည်)", "brand" => "VK", "qty" => 2, "buying" => "8800", "selling" => "12500"},
  %{"oem" => "MR-529135", "sakura" => "FS-6508", "car" => "UNKNOWN", "brand" => "JS", "qty" => 1, "buying" => "9300", "selling" => "14000"},
  %{"oem" => "MR-529135", "sakura" => "FS-6508", "car" => "UNKNOWN", "brand" => "JUKO", "qty" => 1, "buying" => "9200", "selling" => "13500"},
  %{"oem" => "MR-526974", "sakura" => "FS-6700", "car" => "UNKNOWN", "brand" => "NTR", "qty" => 1, "buying" => "8900", "selling" => "13000"},
  %{"oem" => "16400-4M45", "sakura" => "FS-7600", "car" => "X TRAIL", "brand" => "HK", "qty" => 1, "buying" => "11500", "selling" => "15500"},
  %{"oem" => "16400-2Y505", "sakura" => "FS-7601", "car" => "X TRAIL", "brand" => "BRISCO", "qty" => 2, "buying" => "16000", "selling" => "21000"}
]

Enum.each(fuel_products_data, fn p ->
  attrs = %{
    oem_number: p["oem"],
    car_name: p["car"] || "UNKNOWN",
    brand: p["brand"],
    stock_qty: p["qty"],
    buying_price: Decimal.new(p["buying"]),
    selling_price: Decimal.new(p["selling"]),
    product_type_id: fuel_filter_type.id,
    product_attributes: [
      %{attribute_name: "SAKURA No.", attribute_value: p["sakura"]}
    ]
  }

  %Product{}
  |> Product.changeset(attrs)
  |> Repo.insert()
end)

shock_bar_type = Inventory.get_product_type_by_name("Shock Bar")

shock_bar_products = [
  %{"oem" => "334399", "car" => "KLUGER", "front_back" => "အရှေ့", "left_right" => "ဘယ်", "brand" => "HMK", "qty" => 1, "buying" => "88500", "selling" => "115000"},
  %{"oem" => "334400", "car" => "KLUGER", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "HMK", "qty" => 1, "buying" => "88500", "selling" => "115000"},
  %{"oem" => "333390", "car" => "NISSAN AD VAN (နွားကြီး)", "front_back" => "အရှေ့", "left_right" => "ဘယ်", "brand" => "HMK", "qty" => 4, "buying" => "77464", "selling" => "105000"},
  %{"oem" => "333391", "car" => "NISSAN AD VAN (နွားကြီး)", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "HMK", "qty" => 4, "buying" => "77464", "selling" => "105000"},
  %{"oem" => "333390", "car" => "NISSAN AD VAN (နွားကြီး)- A LUK", "front_back" => "အရှေ့", "left_right" => "ဘယ်", "brand" => "EEP", "qty" => 2, "buying" => "75000", "selling" => "102000"},
  %{"oem" => "333391", "car" => "NISSAN AD VAN (နွားကြီး)- A LUK", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "EEP", "qty" => 2, "buying" => "75000", "selling" => "102000"},
  %{"oem" => "333331", "car" => "HONDA GD1", "front_back" => "အရှေ့", "left_right" => "ဘယ်", "brand" => "HMK", "qty" => 2, "buying" => "72000", "selling" => "99000"},
  %{"oem" => "333332", "car" => "HONDA GD1", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "HMK", "qty" => 2, "buying" => "72000", "selling" => "99000"},
  %{"oem" => "334235", "car" => "MITSUBISHI GRANDIC", "front_back" => "အရှေ့", "left_right" => "ဘယ်", "brand" => "HMK", "qty" => 1, "buying" => "81000", "selling" => "108000"},
  %{"oem" => "334236", "car" => "MITSUBISHI GRANDIC", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "HMK", "qty" => 1, "buying" => "81000", "selling" => "108000"},
  %{"oem" => "334235", "car" => "MITSUBISHI GRANDIC-A LUK", "front_back" => "အရှေ့", "left_right" => "ဘယ်", "brand" => "EEP", "qty" => 1, "buying" => "80000", "selling" => "105000"},
  %{"oem" => "334236", "car" => "MITSUBISHI GRANDIC-A LUK", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "EEP", "qty" => 1, "buying" => "80000", "selling" => "105000"},
  %{"oem" => "338001", "car" => "HONDA GE6", "front_back" => "အရှေ့", "left_right" => "ဘယ်", "brand" => "HMK", "qty" => 1, "buying" => "78338", "selling" => "107000"},
  %{"oem" => "338002", "car" => "HONDA GE6", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "HMK", "qty" => 1, "buying" => "78338", "selling" => "107000"},
  %{"oem" => "339080", "car" => "MITSUBISHI OUT LATER / RVR", "front_back" => "အရှေ့", "left_right" => "ဘယ်", "brand" => "HMK", "qty" => 1, "buying" => "83000", "selling" => "112000"},
  %{"oem" => "339081", "car" => "MITSUBISHI OUT LATER / RVR", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "HMK", "qty" => 1, "buying" => "83000", "selling" => "112000"},
  %{"oem" => "334319", "car" => "IPSUM", "front_back" => "အရှေ့", "left_right" => "ဘယ်", "brand" => "HMK", "qty" => 0, "buying" => "88596", "selling" => "115000"},
  %{"oem" => "334320", "car" => "IPSUM", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "HMK", "qty" => 0, "buying" => "88596", "selling" => "115000"},
  %{"oem" => "339196", "car" => "NISSAN X TRAIL-2007 (ပုံပြောင်း)", "front_back" => "အရှေ့", "left_right" => "ဘယ်", "brand" => "HMK", "qty" => 2, "buying" => "82000", "selling" => "111000"},
  %{"oem" => "339197", "car" => "NISSAN X TRAIL-2007 (ပုံပြောင်း)", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "HMK", "qty" => 2, "buying" => "82000", "selling" => "111000"},
  %{"oem" => "333197", "car" => "CALDINA 2WD-4WD", "front_back" => "အရှေ့", "left_right" => "ဘယ်", "brand" => "HMK", "qty" => 1, "buying" => "79000", "selling" => "109000"},
  %{"oem" => "333198", "car" => "CALDINA 2WD-4WD", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "HMK", "qty" => 1, "buying" => "79000", "selling" => "109000"},
  %{"oem" => "341397", "car" => "VIGO 2WD", "front_back" => "အရှေ့", "left_right" => "ဘယ်", "brand" => "EEP", "qty" => 2, "buying" => "86000", "selling" => "116000"},
  %{"oem" => "341398", "car" => "VIGO 2WD", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "EEP", "qty" => 2, "buying" => "86000", "selling" => "116000"},
  %{"oem" => "344222", "car" => "PAJEIO-46", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "KYB", "qty" => 2, "buying" => "90000", "selling" => "122000"},
  %{"oem" => "333310", "car" => "NISSAN AD VAN", "front_back" => "အရှေ့", "left_right" => "ဘယ်", "brand" => "ဘူးမဲ", "qty" => 1, "buying" => "77000", "selling" => "105000"},
  %{"oem" => "333311", "car" => "NISSAN AD VAN", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "ဘူးမဲ", "qty" => 1, "buying" => "77000", "selling" => "105000"},
  %{"oem" => "551112", "car" => "MARK X / CROWN 2004", "front_back" => "အရှေ့", "left_right" => "ဘယ်", "brand" => "USEKA", "qty" => 3, "buying" => "85000", "selling" => "113000"},
  %{"oem" => "551113", "car" => "MARK X / CROWN 2004", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "USEKA", "qty" => 3, "buying" => "85000", "selling" => "113000"},
  %{"oem" => "331035", "car" => "CRV RD5 (2001-2007) A LUK", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "EEP", "qty" => 1, "buying" => "141000", "selling" => "165000"},
  %{"oem" => "331036", "car" => "CRV RD5 (2001-2007) A LUK", "front_back" => "အရှေ့", "left_right" => "ဘယ်", "brand" => "EEP", "qty" => 1, "buying" => "141000", "selling" => "165000"},
  %{"oem" => "471025", "car" => "CRV 96 / 99", "front_back" => "အရှေ့", "left_right" => "ညာ", "brand" => "ADD (ဘူးနီ)", "qty" => 2, "buying" => "65800", "selling" => "95000"}
]

Enum.each(shock_bar_products, fn p ->
  attrs = %{
    oem_number: p["oem"],
    car_name: p["car"],
    brand: p["brand"],
    stock_qty: p["qty"],
    buying_price: Decimal.new(p["buying"]),
    selling_price: Decimal.new(p["selling"]),
    product_type_id: shock_bar_type.id,
    product_attributes: [
      %{attribute_name: "အရှေ့/အနောက်", attribute_value: p["front_back"]},
      %{attribute_name: "ဘယ််/ညာ", attribute_value: p["left_right"] || "ညာ"}
    ]
  }

  %Product{}
  |> Product.changeset(attrs)
  |> Repo.insert()
end)

spring_coil_type = Inventory.get_product_type_by_name("Spring Coil")

spring_coil_products = [
  %{"oem" => "-", "car" => "WISH / FIELDER", "size" => "14 mm", "position" => "အရှေ့", "brand" => "HMK", "qty" => 8, "buying" => "46500", "selling" => "63000"},
  %{"oem" => "-", "car" => "PROBOX", "size" => "14 mm", "position" => "အရှေ့", "brand" => "HMK", "qty" => 4, "buying" => "44000", "selling" => "61000"},
  %{"oem" => "-", "car" => "HARRIER", "size" => "13 mm", "position" => "အရှေ့", "brand" => "HMK", "qty" => 2, "buying" => "47000", "selling" => "64000"},
  %{"oem" => "46831-6A880", "car" => "PRADO", "size" => "16 mm", "position" => "အရှေ့", "brand" => "HMK", "qty" => 2, "buying" => "58000", "selling" => "75000"},
  %{"oem" => "-", "car" => "VIGO / REVO", "size" => "16 mm", "position" => "အရှေ့", "brand" => "HMK", "qty" => 6, "buying" => "60000", "selling" => "80000"},
  %{"oem" => "-", "car" => "CRV RD1", "size" => "12 mm", "position" => "အရှေ့", "brand" => "HMK", "qty" => 2, "buying" => "42000", "selling" => "59000"},
  %{"oem" => "-", "car" => "HONDA FIT", "size" => "12 mm", "position" => "အရှေ့", "brand" => "HMK", "qty" => 2, "buying" => "43000", "selling" => "60000"},
  %{"oem" => "-", "car" => "X-TRAIL (ပုံပြောင်း)", "size" => "13 mm", "position" => "အရှေ့", "brand" => "HMK", "qty" => 4, "buying" => "46000", "selling" => "62000"},
  %{"oem" => "-", "car" => "X-TRAIL (ပုံဟောင်း)", "size" => "13 mm", "position" => "အရှေ့", "brand" => "HMK", "qty" => 0, "buying" => "46500", "selling" => "58000"},
  %{"oem" => "-", "car" => "HIJET (9)", "size" => "13 mm", "position" => "အရှေ့", "brand" => "HMK", "qty" => 4, "buying" => "33000", "selling" => "49000"},
  %{"oem" => "-", "car" => "HIJET (7)", "size" => "13 mm", "position" => "အရှေ့", "brand" => "HMK", "qty" => 2, "buying" => "32000", "selling" => "48000"},
  %{"oem" => "52401-S10-Y03", "car" => "HONDA CRV", "size" => "12 mm", "position" => "အရှေ့", "brand" => "HMK", "qty" => 4, "buying" => "46000", "selling" => "61000"},
  %{"oem" => "-", "car" => "ADVAN (နွားကြီး)", "size" => "13 mm", "position" => "အရှေ့", "brand" => "HMK", "qty" => 4, "buying" => "44000", "selling" => "59000"},
  %{"oem" => "-", "car" => "ADVAN (နွားကြီး)", "size" => "13 mm", "position" => "အရှေ့", "brand" => "ဂျပန်ကျ", "qty" => 2, "buying" => "46000", "selling" => "62000"},
  %{"oem" => "48231-6A330", "car" => "PRADO", "size" => "17 mm", "position" => "အနောက်", "brand" => "HMK", "qty" => 0, "buying" => "62000", "selling" => "85000"},
  %{"oem" => "-", "car" => "ADVAN (နွားကြီး)", "size" => "13 mm", "position" => "အနောက်", "brand" => "HMK", "qty" => 6, "buying" => "45000", "selling" => "63000"},
  %{"oem" => "-", "car" => "HARRIER (ကြီး)", "size" => "13 mm", "position" => "အနောက်", "brand" => "HMK", "qty" => 2, "buying" => "48000", "selling" => "66000"},
  %{"oem" => "-", "car" => "PAJERO IO", "size" => "12 mm", "position" => "အနောက်", "brand" => "HMK", "qty" => 4, "buying" => "43000", "selling" => "60000"},
  %{"oem" => "-", "car" => "SURF 4 / 5", "size" => "12 mm", "position" => "အနောက်", "brand" => "ဂျပန်ကျ", "qty" => 2, "buying" => "47000", "selling" => "66000"},
  %{"oem" => "-", "car" => "SURF 4 / 5", "size" => "14 mm", "position" => "အနောက်", "brand" => "HMK", "qty" => 2, "buying" => "49000", "selling" => "68000"},
  %{"oem" => "-", "car" => "PROBOX", "size" => "16 mm", "position" => "အနောက်", "brand" => "HMK", "qty" => 2, "buying" => "52000", "selling" => "70000"},
  %{"oem" => "-", "car" => "X-TRAIL (ပုံပြောင်း)", "size" => "13 mm", "position" => "အနောက်", "brand" => "OBK", "qty" => 2, "buying" => "100760", "selling" => "135000"}
]

Enum.each(spring_coil_products, fn p ->
  attrs = %{
    oem_number: p["oem"] || "UNLISTED",
    car_name: p["car"],
    brand: p["brand"],
    stock_qty: p["qty"],
    buying_price: Decimal.new(p["buying"]),
    selling_price: Decimal.new(p["selling"]),
    product_type_id: spring_coil_type.id,
    product_attributes: [
      %{attribute_name: "SIZE", attribute_value: p["size"] || "13 mm"},
      %{attribute_name: "အရှေ့/အနောက်", attribute_value: p["position"]}
    ]
  }

  %Product{}
  |> Product.changeset(attrs)
  |> Repo.insert()
end)

engine_mounting_type = Inventory.get_product_type_by_name("Engine Mounting")

engine_mounting_products = [
  %{"oem" => "12372-28020", "car" => "ALPHARD / KLUGER", "position" => "E / L", "brand" => "-", "qty" => 2, "buying" => "63000", "selling" => "82000"},
  %{"oem" => "12362-28100", "car" => "ALPHARD / KLUGER", "position" => "E / R", "brand" => "VOCARGLE", "qty" => 2, "buying" => "68000", "selling" => "87000"},
  %{"oem" => "12305-28120", "car" => "1AZ", "position" => "E", "brand" => "-", "qty" => 5, "buying" => "46000", "selling" => "62000"},
  %{"oem" => "12361-70230", "car" => "MARK II", "position" => "E", "brand" => "-", "qty" => 4, "buying" => "36500", "selling" => "52000"},
  %{"oem" => "11610-60K00", "car" => "K6A", "position" => "E", "brand" => "GOODRUBBER", "qty" => 4, "buying" => "21000", "selling" => "33000"},
  %{"oem" => "111210-ED50A", "car" => "AD VAN 1.5", "position" => "E", "brand" => "VOCARGLE", "qty" => 2, "buying" => "70000", "selling" => "90000"},
  %{"oem" => "50821-SAA-013", "car" => "HONDA FIT GD1", "position" => "E", "brand" => "IQ", "qty" => 1, "buying" => "32000", "selling" => "47000"},
  %{"oem" => "50821-SAA-013", "car" => "HONDA FIT GD1", "position" => "E", "brand" => "-", "qty" => 4, "buying" => "45000", "selling" => "60000"},
  %{"oem" => "-", "car" => "PAJERO-4M40", "position" => "E", "brand" => "-", "qty" => 2, "buying" => "38000", "selling" => "53000"},
  %{"oem" => "12361-35050 / 54120", "car" => "1KZ", "position" => "E", "brand" => "IQ", "qty" => 3, "buying" => "13000", "selling" => "28000"},
  %{"oem" => "-", "car" => "HIJET", "position" => "E", "brand" => "-", "qty" => 7, "buying" => "18000", "selling" => "28000"},
  %{"oem" => "11220-T6010", "car" => "NISSAN ATLAS", "position" => "E-F-L", "brand" => "-", "qty" => 4, "buying" => "24000", "selling" => "37000"},
  %{"oem" => "11220-T6010", "car" => "NISSAN ATLAS", "position" => "E-F-R", "brand" => "-", "qty" => 2, "buying" => "24000", "selling" => "37000"},
  %{"oem" => "11220-27G00", "car" => "NISSAN DYNA", "position" => "E", "brand" => "-", "qty" => 2, "buying" => "11000", "selling" => "18000"},
  %{"oem" => "-", "car" => "NISSAN ATLAS", "position" => "E-R-L", "brand" => "-", "qty" => 1, "buying" => "12500", "selling" => "19000"},
  %{"oem" => "-", "car" => "NISSAN ATLAS", "position" => "E-R-R", "brand" => "-", "qty" => 3, "buying" => "13000", "selling" => "20000"},
  %{"oem" => "-", "car" => "PROBOX", "position" => "E", "brand" => "JAPAN", "qty" => 1, "buying" => "23000", "selling" => "34000"},
  %{"oem" => "-", "car" => "GE6", "position" => "E", "brand" => "JAPAN", "qty" => 1, "buying" => "24000", "selling" => "35000"},
  %{"oem" => "50821-S84-A01", "car" => "UNKNOWN", "position" => "E", "brand" => "YOKI", "qty" => 1, "buying" => "25000", "selling" => "36000"},
  %{"oem" => "-", "car" => "X TRAIL", "position" => "E", "brand" => "JAPAN", "qty" => 1, "buying" => "28000", "selling" => "39000"},
  %{"oem" => "-", "car" => "CRV 99", "position" => "E", "brand" => "-", "qty" => 1, "buying" => "27000", "selling" => "37000"},
  %{"oem" => "50822-TF0-J02", "car" => "HONDA FIT GE6", "position" => "E", "brand" => "GOODRUBBER", "qty" => 1, "buying" => "75000", "selling" => "95000"},
  %{"oem" => "-", "car" => "WISH 2WD", "position" => "G", "brand" => "-", "qty" => 1, "buying" => "25000", "selling" => "37000"},
  %{"oem" => "-", "car" => "HIJET", "position" => "G", "brand" => "-", "qty" => 2, "buying" => "14500", "selling" => "25000"},
  %{"oem" => "-", "car" => "CRV 99", "position" => "G", "brand" => "-", "qty" => 1, "buying" => "25000", "selling" => "37000"},
  %{"oem" => "-", "car" => "CRV 99", "position" => "OUT GUN", "brand" => "-", "qty" => 1, "buying" => "21000", "selling" => "32000"},
  %{"oem" => "-", "car" => "HONDA FIT GE6", "position" => "ဗိုက်တန်း", "brand" => "JAPAN", "qty" => 1, "buying" => "25000", "selling" => "37000"},
  %{"oem" => "50805-SAA-982", "car" => "HONDA FIT GD1", "position" => "G", "brand" => "IQ", "qty" => 2, "buying" => "32000", "selling" => "43000"},
  %{"oem" => "50805-SAA-982", "car" => "HONDA FIT GD1", "position" => "G", "brand" => "-", "qty" => 2, "buying" => "48500", "selling" => "61000"},
  %{"oem" => "-", "car" => "HONDA GE6", "position" => "G", "brand" => "JAPAN", "qty" => 2, "buying" => "25000", "selling" => "36000"},
  %{"oem" => "12371-67020", "car" => "1KZ", "position" => "G", "brand" => "VOCARGLE", "qty" => 2, "buying" => "47500", "selling" => "65000"},
  %{"oem" => "50842-SR3-030", "car" => "CRV 99", "position" => "F-L", "brand" => "ရှေ့ပူလီ", "qty" => 1, "buying" => "25000", "selling" => "37000"},
  %{"oem" => "50841-SR3-030", "car" => "CRV 99", "position" => "F-R", "brand" => "ရှေ့ပူလီ", "qty" => 2, "buying" => "25000", "selling" => "37000"},
  %{"oem" => "-", "car" => "WISH 4WD", "position" => "စီယာတိုင်ဂန်းအောက်", "brand" => "-", "qty" => 1, "buying" => "25000", "selling" => "37000"},
  %{"oem" => "-", "car" => "PAJERO-46", "position" => "ဆောင့်တုံး", "brand" => "RBI", "qty" => 1, "buying" => "15000", "selling" => "27000"}
]

Enum.each(engine_mounting_products, fn p ->
  attrs = %{
    oem_number: p["oem"] || "UNKNOWN",
    car_name: p["car"] || "UNKNOWN",
    brand: p["brand"] || "UNKNOWN",
    stock_qty: p["qty"],
    buying_price: Decimal.new(p["buying"]),
    selling_price: Decimal.new(p["selling"]),
    product_type_id: engine_mounting_type.id,
    product_attributes: [
      %{attribute_name: "POSITION", attribute_value: p["position"]}
    ]
  }

  %Product{}
  |> Product.changeset(attrs)
  |> Repo.insert()
end)

brake_pad_type = Inventory.get_product_type_by_name("Brake Pad")

brake_pad_products = [
  %{"oem" => "D-6039", "car" => "PAJERO 46", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 10, "buying" => "26000", "selling" => "38000"},
  %{"oem" => "D-6039", "car" => "PAJERO 46", "position" => "ရှေ့", "brand" => "INKK", "qty" => 1, "buying" => "25000", "selling" => "37000"},
  %{"oem" => "D-6039", "car" => "PAJERO 46", "position" => "ရှေ့", "brand" => "MU", "qty" => 1, "buying" => "25000", "selling" => "37000"},
  %{"oem" => "D-5011", "car" => "GD1 / GE6", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 21, "buying" => "15750", "selling" => "30000"},
  %{"oem" => "D-0038", "car" => "HIJET", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 10, "buying" => "17000", "selling" => "35000"},
  %{"oem" => "D-2223", "car" => "ALPHARD", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 3, "buying" => "22000", "selling" => "36000"},
  %{"oem" => "D-2223", "car" => "ALPHARD", "position" => "ရှေ့", "brand" => "HMK", "qty" => 1, "buying" => "31760", "selling" => "42000"},
  %{"oem" => "D-2242 / 2193", "car" => "CROWN / MARK X", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 3, "buying" => "18000", "selling" => "32000"},
  %{"oem" => "D-2242 / 2193", "car" => "CROWN / MARK X", "position" => "ရှေ့", "brand" => "HMK", "qty" => 3, "buying" => "34822", "selling" => "48000"},
  %{"oem" => "D-2082 / D-2160", "car" => "PRADO", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 19, "buying" => "22000", "selling" => "36000"},
  %{"oem" => "D-2104", "car" => "HIACE", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 9, "buying" => "24000", "selling" => "37000"},
  %{"oem" => "D-2104", "car" => "HIACE", "position" => "ရှေ့", "brand" => "HMK", "qty" => 2, "buying" => "23500", "selling" => "36000"},
  %{"oem" => "D-2218", "car" => "KLUGER", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 10, "buying" => "26000", "selling" => "39000"},
  %{"oem" => "D-2218", "car" => "KLUGER", "position" => "ရှေ့", "brand" => "HMK", "qty" => 1, "buying" => "25500", "selling" => "38000"},
  %{"oem" => "D-2218", "car" => "KLUGER", "position" => "ရှေ့", "brand" => "INKK", "qty" => 1, "buying" => "25000", "selling" => "37000"},
  %{"oem" => "D-2218", "car" => "KLUGER", "position" => "ရှေ့", "brand" => "MU", "qty" => 1, "buying" => "25000", "selling" => "37000"},
  %{"oem" => "D-2222", "car" => "WISH", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 24, "buying" => "21500", "selling" => "33000"},
  %{"oem" => "D-6062", "car" => "CANTER", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 3, "buying" => "21000", "selling" => "34000"},
  %{"oem" => "D-6062", "car" => "CANTER", "position" => "ရှေ့", "brand" => "WIN WORLD", "qty" => 2, "buying" => "20800", "selling" => "33000"},
  %{"oem" => "D-1250", "car" => "AD VAN", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 15, "buying" => "16000", "selling" => "29000"}
]

Enum.each(brake_pad_products, fn p ->
  attrs = %{
    oem_number: p["oem"],
    car_name: p["car"],
    brand: p["brand"],
    stock_qty: p["qty"],
    buying_price: Decimal.new(p["buying"]),
    selling_price: Decimal.new(p["selling"]),
    product_type_id: brake_pad_type.id,
    product_attributes: [
      %{attribute_name: "POSITION", attribute_value: p["position"]}
    ]
  }

  %Product{}
  |> Product.changeset(attrs)
  |> Repo.insert()
end)

brake_pad_type = Inventory.get_product_type_by_name("Brake Pad")

brake_pad_products = [
  %{"oem" => "D-6039", "car" => "PAJERO 46", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 10, "buying" => "26000", "selling" => "38000"},
  %{"oem" => "D-6039", "car" => "PAJERO 46", "position" => "ရှေ့", "brand" => "INKK", "qty" => 1, "buying" => "25000", "selling" => "37000"},
  %{"oem" => "D-6039", "car" => "PAJERO 46", "position" => "ရှေ့", "brand" => "MU", "qty" => 1, "buying" => "25000", "selling" => "37000"},
  %{"oem" => "D-5011", "car" => "GD1 / GE6", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 21, "buying" => "15750", "selling" => "30000"},
  %{"oem" => "D-0038", "car" => "HIJET", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 10, "buying" => "17000", "selling" => "35000"},
  %{"oem" => "D-2223", "car" => "ALPHARD", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 3, "buying" => "22000", "selling" => "36000"},
  %{"oem" => "D-2223", "car" => "ALPHARD", "position" => "ရှေ့", "brand" => "HMK", "qty" => 1, "buying" => "31760", "selling" => "42000"},
  %{"oem" => "D-2242 / 2193", "car" => "CROWN / MARK X", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 3, "buying" => "18000", "selling" => "32000"},
  %{"oem" => "D-2242 / 2193", "car" => "CROWN / MARK X", "position" => "ရှေ့", "brand" => "HMK", "qty" => 3, "buying" => "34822", "selling" => "48000"},
  %{"oem" => "D-2082 / D-2160", "car" => "PRADO", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 19, "buying" => "22000", "selling" => "36000"},
  %{"oem" => "D-2104", "car" => "HIACE", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 9, "buying" => "24000", "selling" => "37000"},
  %{"oem" => "D-2104", "car" => "HIACE", "position" => "ရှေ့", "brand" => "HMK", "qty" => 2, "buying" => "23500", "selling" => "36000"},
  %{"oem" => "D-2218", "car" => "KLUGER", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 10, "buying" => "26000", "selling" => "39000"},
  %{"oem" => "D-2218", "car" => "KLUGER", "position" => "ရှေ့", "brand" => "HMK", "qty" => 1, "buying" => "25500", "selling" => "38000"},
  %{"oem" => "D-2218", "car" => "KLUGER", "position" => "ရှေ့", "brand" => "INKK", "qty" => 1, "buying" => "25000", "selling" => "37000"},
  %{"oem" => "D-2218", "car" => "KLUGER", "position" => "ရှေ့", "brand" => "MU", "qty" => 1, "buying" => "25000", "selling" => "37000"},
  %{"oem" => "D-2222", "car" => "WISH", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 24, "buying" => "21500", "selling" => "33000"},
  %{"oem" => "D-6062", "car" => "CANTER", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 3, "buying" => "21000", "selling" => "34000"},
  %{"oem" => "D-6062", "car" => "CANTER", "position" => "ရှေ့", "brand" => "WIN WORLD", "qty" => 2, "buying" => "20800", "selling" => "33000"},
  %{"oem" => "D-1250", "car" => "AD VAN", "position" => "ရှေ့", "brand" => "UNITRUCK", "qty" => 15, "buying" => "16000", "selling" => "29000"}
]

Enum.each(brake_pad_products, fn p ->
  attrs = %{
    oem_number: p["oem"],
    car_name: p["car"],
    brand: p["brand"],
    stock_qty: p["qty"],
    buying_price: Decimal.new(p["buying"]),
    selling_price: Decimal.new(p["selling"]),
    product_type_id: brake_pad_type.id,
    product_attributes: [
      %{attribute_name: "POSITION", attribute_value: p["position"]}
    ]
  }

  %Product{}
  |> Product.changeset(attrs)
  |> Repo.insert()
end)

clutch_brake_type = Inventory.get_product_type_by_name("Clutch Brake")

clutch_brake_products = [
  %{"oem" => "31250-87569", "spec" => "20T", "car" => "HIJET", "brand" => "LOOK", "qty" => 5, "buying" => "34075", "selling" => "48000"},
  %{"oem" => "SZD024", "spec" => "18T x 6.8\"", "car" => "SUZUKI CARRY", "brand" => "BRISCO", "qty" => 3, "buying" => "33000", "selling" => "46000"},
  %{"oem" => "DT-068", "spec" => "21T x 9.5\"", "car" => "5L", "brand" => "BRISCO", "qty" => 3, "buying" => "56500", "selling" => "72000"},
  %{"oem" => "ISD128U", "spec" => "24T x 9.5\"", "car" => "NISSAN CASTAR", "brand" => "BRISCO", "qty" => 1, "buying" => "57000", "selling" => "73000"},
  %{"oem" => "B602-16-460", "spec" => "22T x 9\"", "car" => "BONGO", "brand" => "BRISCO", "qty" => 2, "buying" => "57500", "selling" => "75000"},
  %{"oem" => "DT-036", "spec" => "21T x 9\"", "car" => "2C / 2Y", "brand" => "BRISCO", "qty" => 3, "buying" => "49000", "selling" => "67000"},
  %{"oem" => "31250-87305", "spec" => "21T x 9.5\"", "car" => "3C, 3L, 3Y", "brand" => "AISIN", "qty" => 1, "buying" => "52000", "selling" => "68000"},
  %{"oem" => "31250-26052", "spec" => "21T x 9\"", "car" => "1G", "brand" => "LOOK", "qty" => 2, "buying" => "47940", "selling" => "64000"},
  %{"oem" => "EXEDY-VG21", "spec" => "21T x 11\"", "car" => "VIGO", "brand" => "EXEDY", "qty" => 2, "buying" => "62000", "selling" => "83000"},
  %{"oem" => "D.90", "spec" => "14T x 11\" (35 mm)", "car" => "4M40 CANTER", "brand" => "DENAI", "qty" => 1, "buying" => "54000", "selling" => "69000"},
  %{"oem" => "D.13", "spec" => "14T x 11\" (30 mm)", "car" => "4M40 CANTER", "brand" => "DENAI", "qty" => 1, "buying" => "53500", "selling" => "68500"},
  %{"oem" => "D.16", "spec" => "14T x 12\" (35 mm)", "car" => "CANTER", "brand" => "DENAI", "qty" => 1, "buying" => "54500", "selling" => "70000"},
  %{"oem" => "D.10", "spec" => "21T x 11\" (29.8 mm)", "car" => "TIGER", "brand" => "DENAI", "qty" => 1, "buying" => "59000", "selling" => "74000"},
  %{"oem" => "MFD015U", "spec" => "14T x 11\"", "car" => "CANTER 4P10", "brand" => "PANDA", "qty" => 1, "buying" => "60000", "selling" => "79000"},
  %{"oem" => "ME520437", "spec" => "14T x 12\"", "car" => "CANTER 4P10", "brand" => "PANDA", "qty" => 2, "buying" => "62000", "selling" => "80000"},
  %{"oem" => "MFD005", "spec" => "14T x 12.5\"", "car" => "6D15", "brand" => "PANDA", "qty" => 1, "buying" => "104025", "selling" => "125000"},
  %{"oem" => "MFD068Y", "spec" => "13\"", "car" => "CANTER 51 / 50", "brand" => "BRISCO", "qty" => 2, "buying" => "65000", "selling" => "83000"},
  %{"oem" => "MFD004U", "spec" => "14T x 12\"", "car" => "UNKNOWN", "brand" => "PANDA", "qty" => 1, "buying" => "78375", "selling" => "95000"},
  %{"oem" => "MFD036U", "spec" => "16T x 12\"", "car" => "CANTER 51 / 50", "brand" => "PANDA", "qty" => 2, "buying" => "78375", "selling" => "95000"}
]

Enum.each(clutch_brake_products, fn p ->
  attrs = %{
    oem_number: p["oem"] || "UNKNOWN",
    car_name: p["car"] || "UNKNOWN",
    brand: p["brand"],
    stock_qty: p["qty"],
    buying_price: Decimal.new(p["buying"]),
    selling_price: Decimal.new(p["selling"]),
    product_type_id: clutch_brake_type.id,
    product_attributes: [
      %{attribute_name: "TEETH x INCH", attribute_value: p["spec"]}
    ]
  }

  %Product{}
  |> Product.changeset(attrs)
  |> Repo.insert()
end)

clutch_cover_type = Inventory.get_product_type_by_name("Clutch Cover")

clutch_cover_products = [
  %{"oem" => "31210-0K040", "spec" => "10.4\"", "car" => "VIGO", "brand" => "SEIKI", "qty" => 1, "buying" => "125000", "selling" => "160000"},
  %{"oem" => "31210-0K190", "spec" => "11\"", "car" => "VIGO", "brand" => "SEIKI", "qty" => 1, "buying" => "122000", "selling" => "158000"},
  %{"oem" => "MZC624", "spec" => "9\"", "car" => "BONGO", "brand" => "SEIKI", "qty" => 2, "buying" => "81000", "selling" => "110000"},
  %{"oem" => "TYC522", "spec" => "9.5\"", "car" => "3C", "brand" => "SEIKI", "qty" => 1, "buying" => "90000", "selling" => "145000"},
  %{"oem" => "TYC535", "spec" => "9\"", "car" => "2C / 3C", "brand" => "SEIKI", "qty" => 2, "buying" => "88000", "selling" => "130000"},
  %{"oem" => "HJ170", "spec" => "6.8\"", "car" => "HIJET", "brand" => "SEIKI", "qty" => 5, "buying" => "53000", "selling" => "75000"},
  %{"oem" => "TYC565", "spec" => "9.5\"", "car" => "5L", "brand" => "KAWA", "qty" => 2, "buying" => "91000", "selling" => "135000"},
  %{"oem" => "TYC519", "spec" => "9 တစ်မတ်", "car" => "3L / 2C / 3C", "brand" => "KAWA", "qty" => 1, "buying" => "87000", "selling" => "125000"},
  %{"oem" => "31210-2120", "spec" => "11\"", "car" => "TIGER", "brand" => "LOOK", "qty" => 1, "buying" => "96000", "selling" => "138000"}
]

Enum.each(clutch_cover_products, fn p ->
  attrs = %{
    oem_number: p["oem"] || "UNKNOWN",
    car_name: p["car"],
    brand: p["brand"],
    stock_qty: p["qty"],
    buying_price: Decimal.new(p["buying"]),
    selling_price: Decimal.new(p["selling"]),
    product_type_id: clutch_cover_type.id,
    product_attributes: [
      %{attribute_name: "TEETH x INCH", attribute_value: p["spec"]}
    ]
  }

  %Product{}
  |> Product.changeset(attrs)
  |> Repo.insert()
end)

gasket_type = Inventory.get_product_type_by_name("Gasket")

gasket_products = [
  %{"oem" => "11115-70050", "car" => "1G", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 8, "buying" => "23776.5", "selling" => "32000"},
  %{"oem" => "11115-75020", "car" => "2RZ", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 3, "buying" => "24000", "selling" => "31000"},
  %{"oem" => "11115-54020", "car" => "2L", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 4, "buying" => "28000", "selling" => "35000"},
  %{"oem" => "11115-54070", "car" => "3L", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 7, "buying" => "27900", "selling" => "34000"},
  %{"oem" => "11115-54120-NK", "car" => "5L", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 9, "buying" => "28000", "selling" => "34500"},
  %{"oem" => "11115-20042", "car" => "1MZ", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 3, "buying" => "48000", "selling" => "63000"},
  %{"oem" => "11115-64060", "car" => "2C", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 5, "buying" => "18000", "selling" => "32000"},
  %{"oem" => "11115-21030-NK", "car" => "1NZ / 2NZ", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 8, "buying" => "18900", "selling" => "29000"},
  %{"oem" => "11115-28020-NK", "car" => "1AZ / 2AZ", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 5, "buying" => "23970", "selling" => "31000"},
  %{"oem" => "11115-67040-NK", "car" => "1KZ", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 1, "buying" => "25000", "selling" => "36000"},
  %{"oem" => "11115-B1030-NK", "car" => "K3VE", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 5, "buying" => "21500", "selling" => "29500"},
  %{"oem" => "11115-40060", "car" => "1KRF", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 5, "buying" => "21000", "selling" => "28500"},
  %{"oem" => "11115-31051", "car" => "4GRSE (2PC-SET)", "size" => "1.80 mm", "brand" => "TOWA", "qty" => 2, "buying" => "47560.5", "selling" => "61000"},
  %{"oem" => "11115-31041", "car" => "3GRSE (2PC-SET)", "size" => "1.80 mm", "brand" => "TOWA", "qty" => 2, "buying" => "47560.5", "selling" => "61000"},
  %{"oem" => "11115-67040-G", "car" => "1KZ", "size" => "1.80 mm", "brand" => "TOWA", "qty" => 4, "buying" => "26000", "selling" => "36000"},
  %{"oem" => "11115-21030-G", "car" => "1NZ / 2NZ", "size" => "1.80 mm", "brand" => "TOWA", "qty" => 6, "buying" => "22000", "selling" => "31000"},
  %{"oem" => "12251-P8R-030-NK", "car" => "B20B", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 6, "buying" => "17000", "selling" => "27000"},
  %{"oem" => "12251-REA-004-NK", "car" => "L13A3 GD1 / GE6", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 2, "buying" => "27000", "selling" => "36000"},
  %{"oem" => "11044-BC20B-NK", "car" => "HR16", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 5, "buying" => "26469", "selling" => "35500"},
  %{"oem" => "11044-6N202-NK", "car" => "QR20", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 2, "buying" => "28000", "selling" => "37500"},
  %{"oem" => "MN-163381-NK", "car" => "4G69", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 3, "buying" => "25000", "selling" => "33000"},
  %{"oem" => "MD-342390-NK", "car" => "6G74", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 2, "buying" => "23500", "selling" => "32000"},
  %{"oem" => "ME-226784-NK", "car" => "4M50", "size" => "1.75 mm", "brand" => "TOWA", "qty" => 2, "buying" => "21762", "selling" => "31000"}
]

Enum.each(gasket_products, fn p ->
  attrs = %{
    oem_number: p["oem"],
    car_name: p["car"],
    brand: p["brand"],
    stock_qty: p["qty"],
    buying_price: Decimal.new(p["buying"]),
    selling_price: Decimal.new(p["selling"]),
    product_type_id: gasket_type.id,
    product_attributes: [
      %{attribute_name: "SIZE", attribute_value: p["size"]}
    ]
  }

  %Product{}
  |> Product.changeset(attrs)
  |> Repo.insert()
end)

# Get the product_type for Tie Rod
{:ok, tie_rod_type} = Inventory.get_product_type_by_name("Tie Rod") |> case do
  nil -> {:error, "Tie Rod product_type not found"}
  val -> {:ok, val}
end

tie_rod_products = [
  %{oem: "53540-SAA-003", ctr_no: "CRT-101", car: "HONDA GD1", position: "L+R", brand: "HMK", qty: 2, buying: "26926", selling: "37000"},
  %{oem: "53540-TF0-003", ctr_no: "CRT-102", car: "HONDA GE6", position: "L+R", brand: "HMK", qty: 2, buying: "26926", selling: "37000"},
  %{oem: "45047-39215", ctr_no: "CRT-103", car: "PRADO", position: "L+R", brand: "HMK", qty: 2, buying: "25634", selling: "36000"},
  %{oem: "45046-39335", ctr_no: "CRT-104", car: "PRADO", position: "L", brand: "HMK", qty: 1, buying: "25634", selling: "36000"},
  %{oem: "45046-59026", ctr_no: "CRT-105", car: "PROBOX", position: "L+R", brand: "HMK", qty: 4, buying: "24864", selling: "35000"},
  %{oem: "45047-29105", ctr_no: "CRT-106", car: "CALDINA", position: "L+R", brand: "HMK", qty: 4, buying: "24500", selling: "34000"},
  %{oem: "45046-49055", ctr_no: "CRT-107", car: "IPSUM", position: "L+R", brand: "HMK", qty: 4, buying: "24600", selling: "34000"},
  %{oem: "45460-39615", ctr_no: "CRT-108", car: "KLUGER", position: "L+R", brand: "HMK", qty: 4, buying: "24800", selling: "34500"},
  %{oem: "45046-09281", ctr_no: "CRT-109", car: "VIGO", position: "-", brand: "HMK", qty: 8, buying: "18680", selling: "27000"},
  %{oem: "53541-S5A-013", ctr_no: "CRT-110", car: "RD5", position: "-", brand: "HMK", qty: 12, buying: "13000", selling: "19000"},
  %{oem: "MB-912519", ctr_no: "CRT-111", car: "PAJERO IO / RVR", position: "-", brand: "HMK", qty: 4, buying: "13000", selling: "19000"},
  %{oem: "HMK-99901", ctr_no: "CRT-112", car: "HYUNDAI STAREX / OUT LANTER", position: "-", brand: "HMK", qty: 2, buying: "19000", selling: "28000"},
  %{oem: "HMK-001", ctr_no: "CRT-113", car: "HIJET", position: "R", brand: "HMK", qty: 14, buying: "17326", selling: "25000"},
  %{oem: "HMK-002", ctr_no: "CRT-114", car: "HIJET", position: "L", brand: "HMK", qty: 13, buying: "17326", selling: "25000"},
  %{oem: "45047-59026", ctr_no: "CET-98 / CET-99", car: "PROBOX", position: "L+R", brand: "HMK", qty: 4, buying: "24864", selling: "35000"},
  %{oem: "45047-59026", ctr_no: "CET-98 / CET-99", car: "PROBOX", position: "L+R", brand: "TOYOTA", qty: 6, buying: "24000", selling: "34000"},
  %{oem: "45046-19265", ctr_no: "CRT-115", car: "WISH", position: "L+R", brand: "SSS", qty: 10, buying: "24000", selling: "33500"},
  %{oem: "53540-SAA-003", ctr_no: "CEHO-17 / 18", car: "GD1", position: "L+R", brand: "CONTTAYA", qty: 10, buying: "26000", selling: "34000"},
  %{oem: "45460-39575", ctr_no: "CET-151", car: "MARK II GOLD FISH", position: "L+R", brand: "IHVSV", qty: 6, buying: "22000", selling: "31000"},
  %{oem: "45470-09030", ctr_no: "CRT-116", car: "ALPHARD", position: "L+R", brand: "EEP", qty: 2, buying: "25000", selling: "34500"},
  %{oem: "45460-39615", ctr_no: "CRT-117", car: "UNKNOWN", position: "L+R", brand: "EEP", qty: 2, buying: "25000", selling: "34000"},
  %{oem: "48520-3S525", ctr_no: "CRT-118", car: "X TRAIL", position: "-", brand: "CJ", qty: 4, buying: "26500", selling: "35000"},
  %{oem: "45406-39135", ctr_no: "CET-75", car: "TIGER 4WD (SHAY)", position: "-", brand: "CJ", qty: 4, buying: "29000", selling: "40000"}
]

Enum.each(tie_rod_products, fn p ->
  attrs = %{
    oem_number: p.oem,
    car_name: p.car,
    brand: p.brand,
    stock_qty: p.qty,
    buying_price: Decimal.new(p.buying),
    selling_price: Decimal.new(p.selling),
    product_type_id: tie_rod_type.id,
    product_attributes: [
      %{attribute_name: "POSITION", attribute_value: p.position},
      %{attribute_name: "CTR NO.", attribute_value: p.ctr_no}
    ]
  }

  %Product{}
  |> Product.changeset(attrs)
  |> Repo.insert()
end)

# Get the product_type for Rack End
{:ok, rack_end_type} = Inventory.get_product_type_by_name("Rack End") |> case do
  nil -> {:error, "Rack End product_type not found"}
  val -> {:ok, val}
end

rack_end_products = [
  %{oem: "45503-09331", ctr_no: "CRT-89", car: "VIGO", brand: "HMK", qty: 2, buying: "22000", selling: "31000"},
  %{oem: "45503-0D041", ctr_no: "CRT-201", car: "IPSUM", brand: "HMK", qty: 2, buying: "21500", selling: "30000"},
  %{oem: "45503-09500", ctr_no: "CRT-202", car: "KLUGER", brand: "HMK", qty: 2, buying: "21800", selling: "30500"},
  %{oem: "45503-39075", ctr_no: "CRT-50", car: "PRADO", brand: "HMK", qty: 1, buying: "22500", selling: "32000"},
  %{oem: "45503-29565", ctr_no: "CRT-203", car: "HIACE", brand: "HMK", qty: 1, buying: "21000", selling: "29500"},
  %{oem: "45503-59045", ctr_no: "CRT-204", car: "PROBOX", brand: "HMK", qty: 4, buying: "20000", selling: "29000"},
  %{oem: "45503-49085", ctr_no: "CRT-78", car: "KLUGER", brand: "EEP", qty: 4, buying: "21500", selling: "30500"},
  %{oem: "53010-SAA-J01", ctr_no: "CRT-205", car: "GD1 / GE6", brand: "EEP", qty: 1, buying: "20800", selling: "29500"},
  %{oem: "45503-19255", ctr_no: "CRT-54", car: "WISH / COROLLA", brand: "TOYOTA", qty: 10, buying: "24000", selling: "33000"},
  %{oem: "45503-39075", ctr_no: "CRT-50", car: "PRADO", brand: "CTR", qty: 2, buying: "23000", selling: "32000"},
  %{oem: "CTR-1001", ctr_no: "CRHO-32", car: "FIT", brand: "CTR", qty: 3, buying: "19500", selling: "28000"},
  %{oem: "CTR-1002", ctr_no: "CRT-54", car: "WISH", brand: "CTR", qty: 1, buying: "20500", selling: "29500"},
  %{oem: "CTR-1003", ctr_no: "CRHO-33", car: "FIT", brand: "CTR", qty: 2, buying: "19800", selling: "29000"},
  %{oem: "45503-09331", ctr_no: "CRT-89", car: "VIGO", brand: "CTR", qty: 1, buying: "22200", selling: "31500"}
]

Enum.each(rack_end_products, fn p ->
  attrs = %{
    oem_number: p.oem || "UNKNOWN",
    car_name: p.car,
    brand: p.brand,
    stock_qty: p.qty,
    buying_price: Decimal.new(p.buying),
    selling_price: Decimal.new(p.selling),
    product_type_id: rack_end_type.id,
    product_attributes: [
      %{attribute_name: "CTR NO.", attribute_value: p.ctr_no}
    ]
  }

  %Product{}
  |> Product.changeset(attrs)
  |> Repo.insert()
end)
