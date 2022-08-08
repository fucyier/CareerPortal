// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
import "./BaseContract.sol";

contract Registration is BaseContract{

    event PersonRegisteredLog(address _personAddress);
    event AkademisyenEkleLog(address _akademisyenAdres,address _universiteAdres, string  _ad,string  _soyad,uint16  _bolum,Unvan _unvan);
    event UniversiteKayitLog(address _universiteAdres,string  _isim, uint8 _ulke);
    event FirmaEkleLog(address _firmaAdres,string  _isim, uint _vergiNo,uint8  _ulke);
    event KamuKurumuEkleLog(address _kamuKurumuAdres,string  _isim,uint8  _ulke);
    event STKEkleLog(address _stkAdres,string  _isim,uint8  _ulke);
    event KursEkleLog(address _kursAdres,string  _isim,uint8  _ulke);
    event SertifikaMerkeziEkleLog(address _smAdres,string  _isim,uint8  _ulke);
    
    constructor (address _yok, address _tobb, address _cb){
        YOK=_yok;
        TOBB=_tobb;
        CB=_cb;
    }
    
 function ekleUniversite(address _universiteAdres,string memory _isim, uint8 _ulke)  public sadeceYOK{
        require(!universiteler[_universiteAdres].durum,
            "Universite Zaten Mevcut"
            );
        //universiteler[_universiteAdres]=Universite(true,_isim, _ulke);
              
        universiteler[_universiteAdres].durum=true;
        universiteler[_universiteAdres].isim=_isim;
        universiteler[_universiteAdres].ulke=_ulke;

        emit UniversiteKayitLog( _universiteAdres, _isim, _ulke);
    }
    /*
  function registerStudent(address _studentAddress,EgitimBilgileri.EducationInfo memory _egitimBilgileri)   public onlyUniversity{
        require(!people[_studentAddress].status,
            "Student exists already"
            );
            
        people[_studentAddress].status=true;
        people[_studentAddress].educations.push(_egitimBilgileri) ;

        emit PersonRegisteredLog( _studentAddress);
    }
    function addYabanciDil(address _studentAddress,YabanciDilBilgileri.YabanciDil memory _ydBilgi)   public Only_Uni_Comp_Publ{
       require(people[_studentAddress].status,
            "Student not exists"
            );
     
        people[_studentAddress].yabanciDiller.push(_ydBilgi) ;

        emit YabanciDilEklendiLog(_ydBilgi.onayKurumTipi, _ydBilgi.onayKurum,  _ydBilgi.basTarih,  _ydBilgi.bitTarih, _ydBilgi.ogretimTipi, _ydBilgi.ogretimDili);
    }
    */
     function ekleAkademisyen(address _akademisyenAdres,address _universiteAdres, string memory _ad, string memory _soyad,uint16 _bolum, Unvan _unvan)   public sadeceUniversite{
        require(!akademisyenler[_akademisyenAdres].durum,
            "Akademisyen Zaten Mevcut"
            );
       //akademisyenler[_akademisyenAdres]=Akademisyen( true,_universiteAdres, _bolum,  _unvan,  _ad,  _soyad);
        akademisyenler[_akademisyenAdres].durum=true;
        akademisyenler[_akademisyenAdres].ad=_ad;
        akademisyenler[_akademisyenAdres].soyad=_soyad;
        akademisyenler[_akademisyenAdres].bolum=_bolum;
        akademisyenler[_akademisyenAdres].unvan=_unvan;

        emit AkademisyenEkleLog( _akademisyenAdres,_universiteAdres,  _ad,  _soyad,  _bolum, _unvan);
    }
  function ekleFirma(address _firmaAdres,string memory _isim, uint _vergiNo,uint8 _ulke) 
  public sadeceTOBB{
        require(!firmalar[_firmaAdres].durum,
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
        require(!kamuKurumlari[_kamuKurumuAdres].durum,
            "Kamu Kurmu Zaten Mevcut"
            );
            
        kamuKurumlari[_kamuKurumuAdres].durum=true;
        kamuKurumlari[_kamuKurumuAdres].isim=_isim;
        kamuKurumlari[_kamuKurumuAdres].ulke=_ulke;

        emit KamuKurumuEkleLog( _kamuKurumuAdres,  _isim, _ulke);
       
    }
     function ekleKurs(address _kursAdres,string memory _isim, uint8 _ulke) 
     public sadece_Uni_Firma_Kamu{
        require(!kurslar[_kursAdres].durum,
            "Kamu Kurumu Zaten Mevcut"
            );
            
        kurslar[_kursAdres].durum=true;
        kurslar[_kursAdres].isim=_isim;
        kurslar[_kursAdres].ulke=_ulke;
        
        emit KursEkleLog( _kursAdres,  _isim, _ulke);
       
    }
     function ekleSTK(address _stkAdres,string memory _isim, uint8 _ulke) 
     public sadeceCB{
        require(!stklar[_stkAdres].durum,
            "Sivil Toplum Kurulusu Zaten Mevcut"
            );
            
        stklar[_stkAdres].durum=true;
        stklar[_stkAdres].isim=_isim;
        stklar[_stkAdres].ulke=_ulke;
        
        emit STKEkleLog( _stkAdres,  _isim, _ulke);
       
    }
     function ekleSertifikaMerkezi(address _smAdres,string memory _isim, uint8 _ulke) 
     public sadeceTOBB{
        require(!sertifikaMerkezleri[_smAdres].durum,
            "Sertifika Merkezi Zaten Mevcut"
            );
            
        //sertifikaMerkezleri[_smAdres]=SertifikaMerkezi(true,_isim,_ulke);
        sertifikaMerkezleri[_smAdres].durum=true;
        sertifikaMerkezleri[_smAdres].isim=_isim;
        sertifikaMerkezleri[_smAdres].ulke=_ulke;
        
        emit SertifikaMerkeziEkleLog( _smAdres,  _isim, _ulke);
       
    }
}

