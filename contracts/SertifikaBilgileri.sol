// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";
import "./BaseProperties.sol";

contract SertifikaBilgileri is BaseProperties {
    uint public id;
    BaseContract baseContract;

    struct SertifikaBilgi {
        uint id;
        address talepEdilenKurum;
        uint alinanTarih;
        uint8 gecerlilikSuresi;
        string sertifikaAdi;
        Onay onayBilgi;
    }

    mapping(address => mapping(uint => SertifikaBilgi)) public sertifikaBilgiListesi;
    address[] public onayBekleyenKisiler;
    SertifikaBilgi[] public sertifikaBilgileri;
       SertifikaBilgi[] public onayBekleyenler;
    mapping(address => uint[]) public kisiSertifikaIdListesi;


    event SertifikaEklendiLog(uint _id, uint _alinanTarih, uint _gecerlilikSuresi);
    event SertifikaGuncellendiLog(uint _sertifikaBilgiId, uint _alinanTarih, uint _gecerlilikSuresi);
    event SertifikaTalepEdildiLog(uint _sertifikaBilgiId, uint _alinanTarih, uint _gecerlilikSuresi);
    event SertifikaTalebiOnaylandiLog(address _onayKurumAdres, uint _tarih);
    constructor(address baseAddress)  {
        baseContract = BaseContract(baseAddress);
        id = 1;
    }
    modifier _yetkiliPaydas{
        require(baseContract.isSertifikaMerkezi(msg.sender),
            "Sadece yetkili paydas bu islemi yapabilir."
        );
        _;
    }
    modifier _sadeceKisi{
        require(baseContract.isKisi(msg.sender),
            "Bu islemi sadece Kisi yapabilir."
        );
        _;
    }
    function ekleSertifikaBilgi(address _kisiAddress, uint _alinanTarih, uint8 _gecerlilikSuresi, string memory _sertifikaAdi) public _yetkiliPaydas {
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");

        uint yeniId = id++;

        sertifikaBilgiListesi[_kisiAddress][yeniId].id = yeniId;
        sertifikaBilgiListesi[_kisiAddress][yeniId].alinanTarih = _alinanTarih;
        sertifikaBilgiListesi[_kisiAddress][yeniId].gecerlilikSuresi = _gecerlilikSuresi;
        sertifikaBilgiListesi[_kisiAddress][yeniId].sertifikaAdi = _sertifikaAdi;
        sertifikaBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum = OnayDurum.Onaylandi;
        sertifikaBilgiListesi[_kisiAddress][yeniId].onayBilgi.zaman = block.timestamp;
        sertifikaBilgiListesi[_kisiAddress][yeniId].onayBilgi.onayAdres = msg.sender;
        kisiSertifikaIdListesi[_kisiAddress].push(yeniId);
        emit SertifikaEklendiLog(yeniId, _alinanTarih, _gecerlilikSuresi);
    }

    function guncelleSertifikaBilgi(address _kisiAddress, uint _sertifikaBilgiId, uint _alinanTarih, uint8 _gecerlilikSuresi, string memory _sertifikaAdi) public _yetkiliPaydas returns (uint){
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        require(sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].id > 1, "Kisinin bu adres ve sertifika id degeri ile kaydi yoktur.");

        sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].alinanTarih = _alinanTarih;
        sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].gecerlilikSuresi = _gecerlilikSuresi;
        sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].sertifikaAdi = _sertifikaAdi;

        sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].onayBilgi.durum = OnayDurum.Onaylandi;
        sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].onayBilgi.zaman = block.timestamp;
        sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].onayBilgi.onayAdres = msg.sender;

        emit SertifikaGuncellendiLog(_sertifikaBilgiId, _alinanTarih, _gecerlilikSuresi);
        return _sertifikaBilgiId;

    }

    function talepEtSertifikaBilgi(address _kisiAddress, address _talepEdilenKurum, uint _alinanTarih, uint8 _gecerlilikSuresi, string memory _sertifikaAdi) public {
        require(baseContract.isKisi(_kisiAddress), "Kisi mevcut degil");
        require(!onayBekliyorMu(_kisiAddress), "Kisinin daha onceden onay bekleyen bir talebi vardir.");
        uint yeniId = id++;
        sertifikaBilgiListesi[_kisiAddress][yeniId].talepEdilenKurum = _talepEdilenKurum;
        sertifikaBilgiListesi[_kisiAddress][yeniId].alinanTarih = _alinanTarih;
        sertifikaBilgiListesi[_kisiAddress][yeniId].gecerlilikSuresi = _gecerlilikSuresi;
        sertifikaBilgiListesi[_kisiAddress][yeniId].sertifikaAdi = _sertifikaAdi;
        sertifikaBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum = OnayDurum.OnayBekliyor;
        sertifikaBilgiListesi[_kisiAddress][yeniId].onayBilgi.talepAdres = _kisiAddress;

        onayBekleyenKisiler.push(_kisiAddress);
        kisiSertifikaIdListesi[_kisiAddress].push(yeniId);
        emit SertifikaTalepEdildiLog(yeniId, _alinanTarih, _gecerlilikSuresi);
    }

    function talepOnaylaSertifikaBilgi(address _kisiAddress, uint _sertifikaBilgiId) public _yetkiliPaydas returns (uint){
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        require(onayBekleyenKisiVeIdMevcutMu(_kisiAddress, _sertifikaBilgiId), "Kisinin onay bekleyen bir talebi yoktur.");
        require(sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].talepEdilenKurum == msg.sender, "Sadece Talep edilen kurum onaylayabilir.");

        sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].onayBilgi.durum = OnayDurum.Onaylandi;
        sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].onayBilgi.onayAdres = msg.sender;
        sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].onayBilgi.zaman = block.timestamp;
        silOnayBekleyenListe(_kisiAddress);
        emit SertifikaTalebiOnaylandiLog(msg.sender, block.timestamp);
        return _sertifikaBilgiId;

    }
    function talepReddetSertifikaBilgi(address _kisiAddress, uint _sertifikaBilgiId) public _yetkiliPaydas returns (uint){
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        require(onayBekleyenKisiVeIdMevcutMu(_kisiAddress, _sertifikaBilgiId), "Kisinin onay bekleyen bir talebi yoktur.");
        require(sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].talepEdilenKurum == msg.sender, "Sadece Talep edilen kurum reddedebilir.");

        sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].onayBilgi.durum = OnayDurum.Reddedildi;
        sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].onayBilgi.onayAdres = msg.sender;
        sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].onayBilgi.zaman = block.timestamp;
        silOnayBekleyenListe(_kisiAddress);
        emit SertifikaTalebiOnaylandiLog(msg.sender, block.timestamp);
        return _sertifikaBilgiId;

    }
    function getirOnayBekleyenListe() public view returns (address[] memory){
        return onayBekleyenKisiler;
    }

    function getirKisininSertifikaIdListe(address _kisiAddress) public view returns (uint[] memory){
        return kisiSertifikaIdListesi[_kisiAddress];
    }

    function getirKisininSertifikaBilgisi(address _kisiAddress, uint _id) public view returns (SertifikaBilgi memory){
        return sertifikaBilgiListesi[_kisiAddress][_id];
    }
    
    function getirKisininSertifikaListesi(address _kisiAddress) public returns (SertifikaBilgi[] memory){
     uint[] memory idliste =  getirKisininSertifikaIdListe(_kisiAddress);
    
        for (uint i = 0; i < idliste.length; i++) {
             sertifikaBilgileri.push(getirKisininSertifikaBilgisi(_kisiAddress,idliste[i]));
            }
        return sertifikaBilgileri;
    }

    function silOnayBekleyenListe(address _kisiAddress) private {

        require(onayBekleyenKisiler.length > 0, "Onay Bekleyen Listesi Bostur");

        if (onayBekleyenKisiler[onayBekleyenKisiler.length - 1] == _kisiAddress) {
            onayBekleyenKisiler.pop();
            return;
        }

        bool kisiVarMi = false;
        uint index;

        for (uint i = 0; i < onayBekleyenKisiler.length - 1; i++) {
            if (onayBekleyenKisiler[i] == _kisiAddress) {
                onayBekleyenKisiler[i] = onayBekleyenKisiler[i + 1];
                kisiVarMi = true;
                index = i;
            }
        }

        if (kisiVarMi == false) revert("Kisi Onay Bekleyen Listesinde Yoktur.");

        for (uint i = index; i < onayBekleyenKisiler.length - 1; i++) {
            onayBekleyenKisiler[i] = onayBekleyenKisiler[i + 1];
        }

        delete onayBekleyenKisiler[onayBekleyenKisiler.length - 1];
        onayBekleyenKisiler.pop();
    }

    function onayBekliyorMu(address _kisiAddress) private view returns (bool){
        for (uint i = 0; i < onayBekleyenKisiler.length; i++) {
            if (onayBekleyenKisiler[i] == _kisiAddress) {
                return true;
            }
        }
        return false;
    }

    function onayBekleyenKisiVeIdMevcutMu(address _kisiAddress, uint _sertifikaId) private view returns (bool){
        for (uint i = 0; i < onayBekleyenKisiler.length; i++) {
            if (onayBekleyenKisiler[i] == _kisiAddress
            && sertifikaBilgiListesi[_kisiAddress][_sertifikaId].id > 0
                && sertifikaBilgiListesi[_kisiAddress][_sertifikaId].onayBilgi.durum == OnayDurum.OnayBekliyor) {
                return true;
            }
        }
        return false;
    }

 function getirOnayBekleyenListesi2() public  returns (SertifikaBilgi[] memory){

        for (uint i = 0; i < onayBekleyenKisiler.length; i++) {
              uint[] memory idliste =  getirKisininSertifikaIdListe(onayBekleyenKisiler[i]);
             for (uint j = 0; j < idliste.length; j++){
               
         
            if ( getirKisininSertifikaBilgisi(onayBekleyenKisiler[i],idliste[j]).talepEdilenKurum==msg.sender){
                onayBekleyenler.push(getirKisininSertifikaBilgisi(onayBekleyenKisiler[i],idliste[j]));
             }
            }
        }

        return onayBekleyenler;
    }
}