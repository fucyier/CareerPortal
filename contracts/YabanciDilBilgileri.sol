// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";
import "./EgitimBilgileri.sol";

contract YabanciDilBilgileri is BaseContract{
  uint public id;
   
    struct YabanciDilBilgi {
         uint id;
           address talepEdilenKurum;
         OnaylayanKurum onayKurumTipi;
         uint basTarih;
         uint bitTarih;
         EgitimBilgileri.OgretimTipi ogretimTipi;
         uint32 dilId;
         Seviye seviye;
         Onay onayBilgi;
        }
        mapping(address=>mapping(uint=>YabanciDilBilgi)) public yabanciDilBilgiListesi;


        event YabanciDilEklendiLog(OnaylayanKurum _onaylayanKurumTipi,uint _basTarih, uint _bitTarih ,EgitimBilgileri.OgretimTipi _ogretimTipi,uint32 _dilId);
        event YabanciDilGuncellendiLog(OnaylayanKurum _onaylayanKurumTipi,uint _basTarih, uint _bitTarih,EgitimBilgileri.OgretimTipi _ogretimTipi,uint32 _dilId);
          event YabanciDilTalepEdildiLog(address _talepEdilenKurum,uint _basTarih, uint _bitTarih,EgitimBilgileri.OgretimTipi _ogretimTipi,uint32 _dilId);

         function ekleYabanciDilBilgi(address _kisiAddress, OnaylayanKurum onayKurumTipi, uint basTarih, uint bitTarih, EgitimBilgileri.OgretimTipi ogretimTipi, uint32 dilId, Seviye seviye)  public sadece_Uni_Firma_Kamu{
             require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
             uint yeniId=id++;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].onayKurumTipi=onayKurumTipi;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].basTarih=basTarih;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].bitTarih=bitTarih;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].ogretimTipi=ogretimTipi;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].dilId=dilId;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].seviye=seviye;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum=OnayDurum.Onaylandi;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].onayBilgi.zaman=block.timestamp;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].onayBilgi.adres=msg.sender;
           
             emit YabanciDilEklendiLog(onayKurumTipi,  basTarih,  bitTarih, ogretimTipi, dilId);
        }
          function guncelleYabanciDilBilgi(address _kisiAddress,uint ydBilgiId, OnaylayanKurum onayKurumTipi, uint basTarih, uint bitTarih, EgitimBilgileri.OgretimTipi ogretimTipi, uint32 dilId, Seviye seviye)  public sadece_Uni_Firma_Kamu returns(uint){
                require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
                
                yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].onayKurumTipi=onayKurumTipi;
                yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].basTarih=basTarih;
                yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].bitTarih=bitTarih;
                yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].ogretimTipi=ogretimTipi;
                yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].dilId=dilId;
                yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].seviye=seviye;
                yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].onayBilgi.durum=OnayDurum.Onaylandi;
                yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].onayBilgi.zaman=block.timestamp;
                yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].onayBilgi.adres=msg.sender;

                emit YabanciDilGuncellendiLog(onayKurumTipi,  basTarih,  bitTarih, ogretimTipi, dilId);
                return ydBilgiId;

        }

    function talepEtYabanciDilBilgi(address _talepEdilenKurum, uint basTarih, uint bitTarih, EgitimBilgileri.OgretimTipi ogretimTipi, uint32 dilId, Seviye seviye)  public sadeceKisi{
             require(kisiler[msg.sender].durum,"Kisi mevcut degil");
             uint yeniId=id++;

             yabanciDilBilgiListesi[msg.sender][yeniId].talepEdilenKurum=_talepEdilenKurum;
             yabanciDilBilgiListesi[msg.sender][yeniId].basTarih=basTarih;
             yabanciDilBilgiListesi[msg.sender][yeniId].bitTarih=bitTarih;
             yabanciDilBilgiListesi[msg.sender][yeniId].ogretimTipi=ogretimTipi;
             yabanciDilBilgiListesi[msg.sender][yeniId].dilId=dilId;
             yabanciDilBilgiListesi[msg.sender][yeniId].seviye=seviye;
             yabanciDilBilgiListesi[msg.sender][yeniId].onayBilgi.durum=OnayDurum.OnayBekliyor;
             yabanciDilBilgiListesi[msg.sender][yeniId].onayBilgi.zaman=block.timestamp;
             yabanciDilBilgiListesi[msg.sender][yeniId].onayBilgi.adres=msg.sender;
           
             emit YabanciDilTalepEdildiLog(_talepEdilenKurum,  basTarih,  bitTarih, ogretimTipi, dilId);
        }

}