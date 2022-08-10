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

         function ekleYabanciDilBilgi(address _kisiAddress, YabanciDilBilgi memory _ydBilgi)  public sadece_Uni_Firma_Kamu{
             require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
             uint yeniId=id++;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].onayKurumTipi=_ydBilgi.onayKurumTipi;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].onayKurum=_ydBilgi.onayKurum;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].basTarih=_ydBilgi.basTarih;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].bitTarih=_ydBilgi.bitTarih;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].ogretimTipi=_ydBilgi.ogretimTipi;
             yabanciDilBilgiListesi[_kisiAddress][yeniId].dilId=_ydBilgi.dilId;
               yabanciDilBilgiListesi[_kisiAddress][yeniId].dilId=_ydBilgi.seviye;
           
             emit YabanciDilEklendiLog(_ydBilgi.onayKurumTipi, _ydBilgi.onayKurum,  _ydBilgi.basTarih,  _ydBilgi.bitTarih, _ydBilgi.ogretimTipi, _ydBilgi.dilId);
        }
          function guncelleYabanciDilBilgi(address _kisiAddress, YabanciDilBilgi memory _ydBilgi)  public sadece_Uni_Firma_Kamu returns(uint){
                require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
                
                yabanciDilBilgiListesi[_kisiAddress][_ydBilgi.id].onayKurumTipi=_ydBilgi.onayKurumTipi;
                yabanciDilBilgiListesi[_kisiAddress][_ydBilgi.id].onayKurum=_ydBilgi.onayKurum;
                yabanciDilBilgiListesi[_kisiAddress][_ydBilgi.id].basTarih=_ydBilgi.basTarih;
                yabanciDilBilgiListesi[_kisiAddress][_ydBilgi.id].bitTarih=_ydBilgi.bitTarih;
                yabanciDilBilgiListesi[_kisiAddress][_ydBilgi.id].ogretimTipi=_ydBilgi.ogretimTipi;
                yabanciDilBilgiListesi[_kisiAddress][_ydBilgi.id].dilId=_ydBilgi.dilId;
                yabanciDilBilgiListesi[_kisiAddress][_ydBilgi.id].seviye=_ydBilgi.seviye;

                emit YabanciDilGuncellendiLog(_ydBilgi.onayKurumTipi, _ydBilgi.onayKurum,  _ydBilgi.basTarih,  _ydBilgi.bitTarih, _ydBilgi.ogretimTipi, _ydBilgi.dilId);
                return    _ydBilgi.id;

        }



}