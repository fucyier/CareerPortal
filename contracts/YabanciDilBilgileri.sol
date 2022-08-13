// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";
import "./EgitimBilgileri.sol";

contract YabanciDilBilgileri is BaseContract{
  uint public id;
   



    struct YabanciDilBilgi {
         uint id;
         OnaylayanKurum onayKurumTipi;
         address onayKurum;
         uint basTarih;
         uint bitTarih;
         EgitimBilgileri.OgretimTipi ogretimTipi;
         uint32 dilId;
         Seviye seviye;
        }
        mapping(address=>mapping(uint=>YabanciDilBilgi)) public yabanciDilBilgiListesi;



        event YabanciDilEklendiLog(OnaylayanKurum _onaylayanKurumTipi,address _onayKurum, uint _basTarih, uint _bitTarih,EgitimBilgileri.OgretimTipi _ogretimTipi,uint32 _dilId);
        event YabanciDilGuncellendiLog(OnaylayanKurum _onaylayanKurumTipi,address _onayKurum, uint _basTarih, uint _bitTarih,EgitimBilgileri.OgretimTipi _ogretimTipi,uint32 _dilId);

         function ekleYabanciDilBilgi(address _kisiAddress, OnaylayanKurum onayKurumTipi, address onayKurum, uint basTarih, uint bitTarih, EgitimBilgileri.OgretimTipi ogretimTipi, uint32 dilId, Seviye seviye)  public sadece_Uni_Firma_Kamu{
             require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
             uint yeniId=id++;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].onayKurumTipi=onayKurumTipi;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].onayKurum=onayKurum;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].basTarih=basTarih;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].bitTarih=bitTarih;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].ogretimTipi=ogretimTipi;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].dilId=dilId;
               yabanciDilBilgiListesi[_kisiAddress][yeniId].seviye=seviye;
           
             emit YabanciDilEklendiLog(onayKurumTipi, onayKurum,  basTarih,  bitTarih, ogretimTipi, dilId);
        }
          function guncelleYabanciDilBilgi(address _kisiAddress,uint ydBilgiId, OnaylayanKurum onayKurumTipi, address onayKurum, uint basTarih, uint bitTarih, EgitimBilgileri.OgretimTipi ogretimTipi, uint32 dilId, Seviye seviye)  public sadece_Uni_Firma_Kamu returns(uint){
                require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
                
                yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].onayKurumTipi=onayKurumTipi;
                yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].onayKurum=onayKurum;
                yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].basTarih=basTarih;
                yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].bitTarih=bitTarih;
                yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].ogretimTipi=ogretimTipi;
                yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].dilId=dilId;
                yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].seviye=seviye;

                emit YabanciDilGuncellendiLog(onayKurumTipi, onayKurum,  basTarih,  bitTarih, ogretimTipi, dilId);
                return    ydBilgiId;

        }



}