// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
import "./BaseContract.sol";

contract Registration {
BaseContract baseContract;
    event KisiLog(address _kisiAdres);

    event UniversiteKayitLog(address _universiteAdres,string  _isim, uint8 _ulke);
    event FirmaEkleLog(address _firmaAdres,string  _isim, uint _vergiNo,uint8  _ulke);
    event KamuKurumuEkleLog(address _kamuKurumuAdres,string  _isim,uint8  _ulke);
    event STKEkleLog(address _stkAdres,string  _isim,uint8  _ulke);
    event KursEkleLog(address _kursAdres,string  _isim,uint8  _ulke);
    event SertifikaMerkeziEkleLog(address _smAdres,string  _isim,uint8  _ulke);
    
    constructor (address _baseContract,address _yok, address _tobb, address _cb){
       baseContract=BaseContract(_baseContract);
       baseContract.paydasTanimla(_yok, _tobb, _cb);
    }
    modifier sadeceYOK{
      require(baseContract.isYOK(msg.sender),
     "Sadece YOK bu islemi yapabilir."
      );
      _;
    }
 function kaydetUniversite(address _universiteAdres,string memory _isim, uint8 _ulke)  public sadeceYOK{
     baseContract.ekleUniversite(_universiteAdres, _isim, _ulke);
     emit UniversiteKayitLog( _universiteAdres, _isim, _ulke);
    }

     function getYOK()  public   view returns(address) {
     return baseContract.getYOK();
    }
/*
     function ekleKisi(address _kisiAdres)  public{
        require(!!baseContract.isKisi(_kisiAdres),
            "Kisi Zaten Mevcut"
            );
      
        kisiler[_kisiAdres].durum=true;

        emit KisiLog(_kisiAdres);
    }


  function ekleFirma(address _firmaAdres,string memory _isim, uint _vergiNo,uint8 _ulke) 
  public sadeceTOBB{
        require(!baseContract.isFirma(_firmaAdres),
            "Firma Zaten Mevcut"
            );
            
        firmalar[_firmaAdres].durum=true;
        firmalar[_firmaAdres].isim=_isim;
        firmalar[_firmaAdres].ulke=_ulke;
        firmalar[_firmaAdres].vergiNo=_vergiNo;

        emit FirmaEkleLog( _firmaAdres,  _isim,  _vergiNo,  _ulke);
       
    }
     function ekleKamuKurumu(address _kamuKurumuAdres,string memory _isim, uint8 _ulke) 
     public sadeceCB{
        require(!baseContract.isKamuKurumu(_kamuKurumuAdres),
            "Kamu Kurmu Zaten Mevcut"
            );
            
        kamuKurumlari[_kamuKurumuAdres].durum=true;
        kamuKurumlari[_kamuKurumuAdres].isim=_isim;
        kamuKurumlari[_kamuKurumuAdres].ulke=_ulke;

        emit KamuKurumuEkleLog( _kamuKurumuAdres,  _isim, _ulke);
       
    }
     function ekleKurs(address _kursAdres,string memory _isim, uint8 _ulke) 
     public sadece_Uni_Firma_Kamu{
        require(!baseContract.isKurs(_kursAdres),
            "Kurs Merkezi Zaten Mevcut"
            );
            
        kurslar[_kursAdres].durum=true;
        kurslar[_kursAdres].isim=_isim;
        kurslar[_kursAdres].ulke=_ulke;
        
        emit KursEkleLog( _kursAdres,  _isim, _ulke);
       
    }
     function ekleSTK(address _stkAdres,string memory _isim, uint8 _ulke) 
     public sadeceCB{
        require(!baseContract.isSTK(_stkAdres),
            "Sivil Toplum Kurulusu Zaten Mevcut"
            );
            
        stklar[_stkAdres].durum=true;
        stklar[_stkAdres].isim=_isim;
        stklar[_stkAdres].ulke=_ulke;
        
        emit STKEkleLog( _stkAdres,  _isim, _ulke);
       
    }
     function ekleSertifikaMerkezi(address _smAdres,string memory _isim, uint8 _ulke) 
     public sadeceTOBB{
        require(baseContract.isSertifikaMerkezi(_smAdres),
            "Sertifika Merkezi Zaten Mevcut"
            );
            
        //sertifikaMerkezleri[_smAdres]=SertifikaMerkezi(true,_isim,_ulke);
        sertifikaMerkezleri[_smAdres].durum=true;
        sertifikaMerkezleri[_smAdres].isim=_isim;
        sertifikaMerkezleri[_smAdres].ulke=_ulke;
        
        emit SertifikaMerkeziEkleLog( _smAdres,  _isim, _ulke);
       
    }
    */
}

