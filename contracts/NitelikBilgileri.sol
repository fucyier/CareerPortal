// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";


contract NitelikBilgileri is BaseContract{
  uint public id;

    struct NitelikBilgi {
         uint id;
         OnaylayanKurum onayKurumTipi;
         address onayKurumAdres;
         uint onayTarih;
         string nitelikAdi;
         string aciklama;
         Seviye seviye;
        }
        mapping(address=>mapping(uint=>NitelikBilgi)) public nitelikBilgiListesi;



        event NitelikEklendiLog(address _onayKurumAdres,uint _tarih, string _nitelikAdi);
        event NitelikGuncellendiLog(address _onayKurumAdres,uint _tarih, string _nitelikAdi);

         function ekleNitelikBilgi(address _kisiAddress, NitelikBilgi memory _nitelikBilgi)  public sadece_Uni_Firma_Kamu{
             require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
             uint yeniId=id++;
             nitelikBilgiListesi[_kisiAddress][yeniId].onayKurumTipi=_nitelikBilgi.onayKurumTipi;
             nitelikBilgiListesi[_kisiAddress][yeniId].onayKurumAdres=_nitelikBilgi.onayKurumAdres;
             nitelikBilgiListesi[_kisiAddress][yeniId].onayTarih=_nitelikBilgi.onayTarih;
             nitelikBilgiListesi[_kisiAddress][yeniId].nitelikAdi=_nitelikBilgi.nitelikAdi;
             nitelikBilgiListesi[_kisiAddress][yeniId].aciklama=_nitelikBilgi.aciklama;
             nitelikBilgiListesi[_kisiAddress][yeniId].seviye=_nitelikBilgi.seviye;
           
            emit NitelikEklendiLog(_nitelikBilgi.onayKurumAdres, _nitelikBilgi.tarih, _nitelikBilgi.nitelikAdi);
        }
          function guncelleNitelikBilgi(address _kisiAddress, NitelikBilgi memory _nitelikBilgi)  public sadece_Uni_Firma_Kamu returns(uint){
                require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
                
             nitelikBilgiListesi[_kisiAddress][_nitelikBilgi.id].kursAdres=_nitelikBilgi.kursAdres;
             nitelikBilgiListesi[_kisiAddress][_nitelikBilgi.id].basTarih=_nitelikBilgi.basTarih;
             nitelikBilgiListesi[_kisiAddress][_nitelikBilgi.id].bitTarih=_nitelikBilgi.bitTarih;
             nitelikBilgiListesi[_kisiAddress][_nitelikBilgi.id].sure=_nitelikBilgi.sure;
             nitelikBilgiListesi[_kisiAddress][_nitelikBilgi.id].egitimAdi=_nitelikBilgi.egitimAdi;
             nitelikBilgiListesi[_kisiAddress][_nitelikBilgi.id].seviye=_nitelikBilgi.seviye;

             emit NitelikGuncellendiLog(_nitelikBilgi.onayKurumAdres, _nitelikBilgi.tarih, _nitelikBilgi.nitelikAdi);
                return    _nitelikBilgi.id;

        }



}