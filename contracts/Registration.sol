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
        modifier sadeceTOBB{
      require(baseContract.isTOBB(msg.sender),
     "Sadece TOBB bu islemi yapabilir."
      );
      _;
    }

      modifier sadeceCB{
      require(baseContract.isCB(msg.sender),
      "Sadece CB bu islemi yapabilir."
      );
      _;
    }    

      modifier sadeceKisi{
      require(baseContract.isKisi(msg.sender),
      "Bu islemi sadece Kisi yapabilir."
      );
      _;
    } 
      modifier sadeceUniversite{
      require(baseContract.isUniversite(msg.sender),
      "Sadece Universite bu islemi yapabilir."
      );
      _;
    } 

      modifier sadeceKurs{
      require(baseContract.isKurs(msg.sender),
      "Bu islemi sadece Kurs yapabilir."
      );
      _;
    } 
        modifier sadeceSertifikaMerkezi{
      require(baseContract.isSertifikaMerkezi(msg.sender),
      "Bu islemi sadece Sertifika Merkezleri yapabilir."
      );
      _;
    } 

      modifier sadece_Uni_Firma_Kamu{
      require(baseContract.isUniversite(msg.sender)||baseContract.isFirma(msg.sender)||baseContract.isKamuKurumu(msg.sender),
      "Bu islemi Universiteler Kamu veya Ozel Kurumlar yapabilir."
      );
      _;
    } 
      modifier onlyKontratSahibi {
      require(msg.sender == address(this),
      "Bu islemi sadece kontrat sahibi yapabilir"
      );
      _;
    }
 function ekleUniversite(address _universiteAdres,string memory _isim, uint8 _ulke)  public sadeceYOK{
     baseContract.ekleUniversite(_universiteAdres, _isim, _ulke);
     emit UniversiteKayitLog( _universiteAdres, _isim, _ulke);
    }



     function ekleKisi(address _kisiAdres)  public{
      
        baseContract.ekleKisi(_kisiAdres);
        emit KisiLog(_kisiAdres);
    }


  function ekleFirma(address _firmaAdres,string memory _isim, uint _vergiNo,uint8 _ulke) 
  public sadeceTOBB{
        require(!baseContract.isFirma(_firmaAdres),
            "Firma Zaten Mevcut"
            );
         baseContract.ekleFirma(_firmaAdres, _isim, _vergiNo, _ulke);

        emit FirmaEkleLog( _firmaAdres,  _isim,  _vergiNo,  _ulke);
       
    }
     function ekleKamuKurumu(address _kamuKurumuAdres,string memory _isim, uint8 _ulke) 
     public sadeceCB{
       baseContract.ekleKamuKurumu(_kamuKurumuAdres, _isim, _ulke);

        emit KamuKurumuEkleLog( _kamuKurumuAdres,  _isim, _ulke);
       
    }
     function ekleKurs(address _kursAdres,string memory _isim, uint8 _ulke) 
     public sadece_Uni_Firma_Kamu{
      
       baseContract.ekleKurs(_kursAdres, _isim, _ulke);
        
        emit KursEkleLog( _kursAdres,  _isim, _ulke);
       
    }
     function ekleSTK(address _stkAdres,string memory _isim, uint8 _ulke) 
     public sadeceCB{
      
            
       baseContract.ekleSTK(_stkAdres, _isim, _ulke);
        
        emit STKEkleLog( _stkAdres,  _isim, _ulke);
       
    }
     function ekleSertifikaMerkezi(address _smAdres,string memory _isim, uint8 _ulke) 
     public sadeceTOBB{
       baseContract.ekleSertifikaMerkezi(_smAdres, _isim, _ulke);
        
        emit SertifikaMerkeziEkleLog( _smAdres,  _isim, _ulke);
       
    }
    
}

