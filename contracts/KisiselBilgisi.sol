// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";


contract KisiselBilgisi is BaseContract{

    struct KisiselBilgi {
         string ad;
         string soyad;
         uint8 ulkeId;
         uint32 sehirId;
        string telefon;
         Cinsiyet cinsiyet;
         AskerlikDurum askerlikDurum;
         uint8 uyrukId;
         EhliyetDurum ehliyetDurum;
         uint16 dogumYil;
        }
        mapping(address=>KisiselBilgi) public kisiselBilgisi;



        event KisiselBilgiEklendiLog(address _kisiAddress,string _ad,string _soyad,uint16 _dogumYil);
        event KisiselBilgiGuncellendiLog(address _kisiAddress,string _ad,string _soyad,uint16 _dogumYil);

         function ekleKisiselBilgi(address _kisiAddress, string memory ad, string memory soyad, uint8 ulkeId, uint32 sehirId, string memory telefon, Cinsiyet cinsiyet, AskerlikDurum askerlikDurum, uint8 uyrukId, EhliyetDurum ehliyetDurum, uint16 dogumYil)  public {
             require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
     
             kisiselBilgisi[_kisiAddress]=KisiselBilgi(ad,
                                                        soyad,
                                                        ulkeId,
                                                        sehirId,
                                                        telefon,
                                                        cinsiyet,
                                                        askerlikDurum,
                                                        uyrukId,
                                                        ehliyetDurum,
                                                       dogumYil);
         
           
             emit KisiselBilgiEklendiLog(_kisiAddress,ad, soyad, dogumYil);
        }
          function guncelleKisiselBilgi(address _kisiAddress,  string memory ad, string memory soyad, uint8 ulkeId, uint32 sehirId, string memory telefon, Cinsiyet cinsiyet, AskerlikDurum askerlikDurum, uint8 uyrukId, EhliyetDurum ehliyetDurum, uint16 dogumYil)  public  returns(address){
                require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
                
                  kisiselBilgisi[_kisiAddress]=KisiselBilgi(ad,
                                                        soyad,
                                                        ulkeId,
                                                        sehirId,
                                                        telefon,
                                                        cinsiyet,
                                                        askerlikDurum,
                                                        uyrukId,
                                                        ehliyetDurum,
                                                        dogumYil);

                emit KisiselBilgiGuncellendiLog(_kisiAddress,ad, soyad, dogumYil);
                return    _kisiAddress;

        }



}