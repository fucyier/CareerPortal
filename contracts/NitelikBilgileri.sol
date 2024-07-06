// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";
import "./BaseProperties.sol";


contract NitelikBilgileri is BaseProperties {

    uint public id;
    BaseContract baseContract;

    struct NitelikBilgi {
        uint id;
        address talepEdilenKurum;
        uint nitelikKodu;
        string aciklama;
        Seviye seviye;
        Onay onayBilgi;
    }

    mapping(address => mapping(uint => NitelikBilgi)) public nitelikBilgiListesi;

    address[] public onayBekleyenKisiler;
    NitelikBilgi[] public nitelikBilgileri;
     NitelikBilgi[] public onayBekleyenler;
    mapping(address => uint[]) public kisiNitelikIdListesi;


    event NitelikEklendiLog(address _onayKurumAdres, uint _tarih, uint _nitelikKodu);
    event NitelikGuncellendiLog(address _onayKurumAdres, uint _tarih, uint _nitelikKodu);
    event NitelikTalepEdildiLog(address _talepEdilenKurum, uint _tarih, uint _nitelikKodu);
    event NitelikTalebiOnaylandiLog(address _onayKurumAdres, uint _tarih);
    
    constructor(address baseAddress)  {
        baseContract = BaseContract(baseAddress);
        id = 1;
    }

    modifier _yetkiliPaydas{
        require(baseContract.isKurs(msg.sender) || baseContract.isKamuKurumu(msg.sender) || baseContract.isFirma(msg.sender) || baseContract.isSertifikaMerkezi(msg.sender),
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

    function ekleNitelikBilgi(address _kisiAddress, uint nitelikKodu, string memory aciklama, Seviye seviye) public _yetkiliPaydas {
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        uint yeniId = id++;
        nitelikBilgiListesi[_kisiAddress][yeniId].id = yeniId;
        nitelikBilgiListesi[_kisiAddress][yeniId].nitelikKodu = nitelikKodu;
        nitelikBilgiListesi[_kisiAddress][yeniId].aciklama = aciklama;
        nitelikBilgiListesi[_kisiAddress][yeniId].seviye = seviye;
        nitelikBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum = OnayDurum.Onaylandi;
        nitelikBilgiListesi[_kisiAddress][yeniId].onayBilgi.onayAdres = msg.sender;
        nitelikBilgiListesi[_kisiAddress][yeniId].onayBilgi.zaman = block.timestamp;
        kisiNitelikIdListesi[_kisiAddress].push(yeniId);
        emit NitelikEklendiLog(msg.sender, block.timestamp, nitelikKodu);
    }
   

    function guncelleNitelikBilgi(address _kisiAddress, uint nitelikBilgiId, uint nitelikKodu, string memory aciklama, Seviye seviye) public _yetkiliPaydas returns (uint){
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        require(nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].id > 1, "Kisinin bu adres ve nitelik id degeri ile kaydi yoktur.");
        nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].nitelikKodu = nitelikKodu;
        nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].aciklama = aciklama;
        nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].seviye = seviye;
        nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.durum = OnayDurum.Onaylandi;
        nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.onayAdres = msg.sender;
        nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.zaman = block.timestamp;

        emit NitelikGuncellendiLog(msg.sender, block.timestamp, nitelikKodu);
        return nitelikBilgiId;

    }

    function talepEtNitelikBilgi(address _kisiAddress, address _talepEdilenKurum, uint nitelikKodu, string memory aciklama, Seviye seviye) public {
        require(baseContract.isKisi(_kisiAddress), "Kisi mevcut degil");
        require(!onayBekliyorMu(_kisiAddress), "Kisinin daha onceden onay bekleyen bir talebi vardir.");
        uint yeniId = id++;

        nitelikBilgiListesi[_kisiAddress][yeniId].id = yeniId;
        nitelikBilgiListesi[_kisiAddress][yeniId].talepEdilenKurum = _talepEdilenKurum;
        nitelikBilgiListesi[_kisiAddress][yeniId].nitelikKodu = nitelikKodu;
        nitelikBilgiListesi[_kisiAddress][yeniId].aciklama = aciklama;
        nitelikBilgiListesi[_kisiAddress][yeniId].seviye = seviye;
        nitelikBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum = OnayDurum.OnayBekliyor;
        nitelikBilgiListesi[_kisiAddress][yeniId].onayBilgi.talepAdres = _kisiAddress;

        onayBekleyenKisiler.push(_kisiAddress);
        kisiNitelikIdListesi[_kisiAddress].push(yeniId);

        emit NitelikEklendiLog(msg.sender, block.timestamp, nitelikKodu);
    }
 
    function talepOnaylaNitelikBilgi(address _kisiAddress, uint nitelikBilgiId) public _yetkiliPaydas returns (uint){
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        require(onayBekleyenKisiVeIdMevcutMu(_kisiAddress, nitelikBilgiId), "Kisinin onay bekleyen bir talebi yoktur.");
        require(nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].talepEdilenKurum == msg.sender, "Sadece Talep edilen kurum onaylayabilir.");

        nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.durum = OnayDurum.Onaylandi;
        nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.onayAdres = msg.sender;
        nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.zaman = block.timestamp;
        silOnayBekleyenListe(_kisiAddress);
        emit NitelikTalebiOnaylandiLog(msg.sender, block.timestamp);
        return nitelikBilgiId;

    }

     function talepReddetNitelikBilgi(address _kisiAddress, uint nitelikBilgiId) public _yetkiliPaydas returns (uint){
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        require(onayBekleyenKisiVeIdMevcutMu(_kisiAddress, nitelikBilgiId), "Kisinin onay bekleyen bir talebi yoktur.");
        require(nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].talepEdilenKurum == msg.sender, "Sadece Talep edilen kurum reddedebilir.");

        nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.durum = OnayDurum.Reddedildi;
        nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.onayAdres = msg.sender;
        nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.zaman = block.timestamp;
        silOnayBekleyenListe(_kisiAddress);
        emit NitelikTalebiOnaylandiLog(msg.sender, block.timestamp);
        return nitelikBilgiId;

    }

    function getirOnayBekleyenListe() public view returns (address[] memory){
        return onayBekleyenKisiler;
    }

    function getirKisininNitelikIdListe(address _kisiAddress) public view returns (uint[] memory){
        return kisiNitelikIdListesi[_kisiAddress];
    }

    function getirKisininNitelikBilgisi(address _kisiAddress, uint _id) public view returns (NitelikBilgi memory){
        return nitelikBilgiListesi[_kisiAddress][_id];
    }

    function getirKisininNitelikListesi(address _kisiAddress) public returns (NitelikBilgi[] memory){
     uint[] memory idliste =  getirKisininNitelikIdListe(_kisiAddress);
    
        for (uint i = 0; i < idliste.length; i++) {
             nitelikBilgileri.push(getirKisininNitelikBilgisi(_kisiAddress,idliste[i]));
            }
        return nitelikBilgileri;
    }





/*


     function _getirOnayBekleyenOnayBekleyen() public view returns (uint ){
        return onayBekleyenKisiler.length;
    }
         function _getirOnayBekleyenOnayBekleyen2(uint a) public view returns (address ){
        return onayBekleyenKisiler[a];
    }
    */
    function _getirOnayBekleyenIdListe() public view returns (uint[] memory){
            uint[] memory idliste =  new uint[](onayBekleyenKisiler.length);
            uint u=0;
        for (uint i = 0; i < onayBekleyenKisiler.length; i++) {
                uint[] memory idliste1=getirKisininNitelikIdListe(onayBekleyenKisiler[i]);
              for (uint j = 0; j < idliste1.length; j++){
                 idliste[u++]=(idliste1[j]);   
              }
        }
        return idliste;
    }







    function getirOnayBekleyenListesi(address _kurumAdresi) public view  returns (NitelikBilgi[] memory){
    NitelikBilgi[] memory onayBekleyenNitelikler2;
    uint u=0;
        for (uint i = 0; i < onayBekleyenKisiler.length; i++) {
              uint[] memory idliste =  getirKisininNitelikIdListe(onayBekleyenKisiler[i]);
             for (uint j = 0; j < idliste.length; j++){
               
            NitelikBilgi memory nitelikBilgi= getirKisininNitelikBilgisi(onayBekleyenKisiler[i],idliste[j]);
            if ( nitelikBilgi.talepEdilenKurum==_kurumAdresi){
                onayBekleyenNitelikler2[u++]=nitelikBilgi;
             }
            }
        }

        return onayBekleyenNitelikler2;
    }

     function getirOnayBekleyenListesi2() public  returns (NitelikBilgi[] memory){

        for (uint i = 0; i < onayBekleyenKisiler.length; i++) {
              uint[] memory idliste =  getirKisininNitelikIdListe(onayBekleyenKisiler[i]);
             for (uint j = 0; j < idliste.length; j++){
               
         
            if ( getirKisininNitelikBilgisi(onayBekleyenKisiler[i],idliste[j]).talepEdilenKurum==msg.sender){
                onayBekleyenler.push(getirKisininNitelikBilgisi(onayBekleyenKisiler[i],idliste[j]));
             }
            }
        }

        return onayBekleyenler;
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

    function onayBekleyenKisiVeIdMevcutMu(address _kisiAddress, uint _nitelikId) private view returns (bool){
        for (uint i = 0; i < onayBekleyenKisiler.length; i++) {
            if (onayBekleyenKisiler[i] == _kisiAddress
            && nitelikBilgiListesi[_kisiAddress][_nitelikId].id > 0
                && nitelikBilgiListesi[_kisiAddress][_nitelikId].onayBilgi.durum == OnayDurum.OnayBekliyor) {
                return true;
            }
        }
        return false;
    }

}