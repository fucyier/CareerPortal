// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";


contract IlanBilgileri is BaseContract{

        uint public id;

        struct IlanBilgi {
         uint id;
         address talepEdenKurum;
         uint32 pozisyon;
         uint8 sektor;
         CalismaTipi calismaTipi;
         string arananOzellikler;
         string isTanimi;
         uint ilanBasTarih;
         uint ilanBitTarih;
         uint8 tecrubeYili;
        // uint8 ulke;
         uint32 sehir;
        }
       
        mapping(uint=>IlanBilgi) public ilanBilgileri;

        event IlanBilgiEklendiLog(uint _id, address _talepEdenKurum, uint32 _pozisyon, uint8 _sektor);
        event IlanBilgiGuncellendiLog(uint _id, address _talepEdenKurum, uint32 _pozisyon, uint8 _sektor);
        

  function ekleIlanBilgi(address _talepEdenKurum, uint32 _pozisyon, uint8 _sektor, CalismaTipi _calismaTipi, string memory _arananOzellikler, string memory _isTanimi, uint _ilanBasTarih, uint _ilanBitTarih, 
                        uint32 _sehir, uint8 _tecrubeYili)  public sadece_Uni_Firma_Kamu{
             require(kamuKurumlari[_talepEdenKurum].durum||firmalar[_talepEdenKurum].durum,"Ilan acan kurum kayitli degil");
             uint yeniId=id++;
            
             ilanBilgileri[yeniId].talepEdenKurum=_talepEdenKurum;
             ilanBilgileri[yeniId].pozisyon=_pozisyon;
             ilanBilgileri[yeniId].sektor=_sektor;
             ilanBilgileri[yeniId].calismaTipi=_calismaTipi;
             ilanBilgileri[yeniId].arananOzellikler=_arananOzellikler;
             ilanBilgileri[yeniId].isTanimi=_isTanimi;
             ilanBilgileri[yeniId].ilanBasTarih=_ilanBasTarih;
             ilanBilgileri[yeniId].ilanBitTarih=_ilanBitTarih;
             ilanBilgileri[yeniId].tecrubeYili=_tecrubeYili;
            // ilanBilgileri[yeniId].ulke=_ulke;
             ilanBilgileri[yeniId].sehir=_sehir;

           
             emit IlanBilgiEklendiLog( yeniId,_talepEdenKurum, _pozisyon,_sektor );
    }
       function guncelleIlanBilgi(uint _ilanId, address _talepEdenKurum, uint32 _pozisyon, uint8 _sektor, CalismaTipi _calismaTipi, string memory _arananOzellikler, string memory _isTanimi, uint _ilanBasTarih, uint _ilanBitTarih, 
                        uint32 _sehir, uint8 _tecrubeYili)  public sadece_Uni_Firma_Kamu returns(uint){
            require(kamuKurumlari[_talepEdenKurum].durum||firmalar[_talepEdenKurum].durum,"Ilan acan kurum kayitli degil");
             
             ilanBilgileri[_ilanId].talepEdenKurum=_talepEdenKurum;
             ilanBilgileri[_ilanId].pozisyon=_pozisyon;
             ilanBilgileri[_ilanId].sektor=_sektor;
             ilanBilgileri[_ilanId].calismaTipi=_calismaTipi;
             ilanBilgileri[_ilanId].arananOzellikler=_arananOzellikler;
             ilanBilgileri[_ilanId].isTanimi=_isTanimi;
             ilanBilgileri[_ilanId].ilanBasTarih=_ilanBasTarih;
             ilanBilgileri[_ilanId].ilanBitTarih=_ilanBitTarih;
             ilanBilgileri[_ilanId].tecrubeYili=_tecrubeYili;
             //ilanBilgileri[_ilanId].ulke=_ulke;
             ilanBilgileri[_ilanId].sehir=_sehir;
           
             emit IlanBilgiGuncellendiLog( _ilanId,_talepEdenKurum, _pozisyon,_sektor );
             return _ilanId;

    }



    
}