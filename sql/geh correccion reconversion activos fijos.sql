


Update i Set i.CostoTotal = Round(i.CostoTotal / 100000, 2), 
			 i.ValorResidual = Round(i.ValorResidual / 100000, 2), 
			 i.MontoADepreciar = Round(i.MontoADepreciar / 100000, 2), 
			 i.MontoDepreciacionMensual = Round(i.MontoDepreciacionMensual / 100000, 2) 
			 
From InventarioActivosFijos i 

Where (i.DepreciarHastaAno < 2018) 
