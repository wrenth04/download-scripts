#!/bin/bash

id="$1"
id=${id:-DGBJG9-A900AZ76T}

while :; do
  data=$(wget -O - -q "https://24h.m.pchome.com.tw/ecapi/ecshop/prodapi/v2/prod/$id&fields=Seq,Id,Name,Nick,Store,PreOrdDate,SpeOrdDate,Price,Discount,Pic,Weight,ISBN,Qty,Bonus,isBig,isSpec,isCombine,isDiy,isRecyclable,isCarrier,isMedical,isBigCart,isSnapUp,isDescAndIntroSync,isFoodContents,isHuge,isEnergySubsidy,isPrimeOnly,isPreOrder24h,isWarranty,isLegalStore,isOnSale,isPriceTask,isFresh,isBidding,isSet,Volume,isArrival24h,isETicket&_callback=jsonp_prodmain&1586573460")

  qty=${data#*Qty\":}; qty=${qty%%,*}

  echo "$(date): $qty"
  sleep 5
done
