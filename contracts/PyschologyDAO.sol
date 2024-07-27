// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PyschologyDAO {
    //Oneri yapisi
    struct Oneri {
        uint id;
        string aciklama;
        uint oySayisi;
        bool uygulandi;
    }

    //Kullanici yapisi
    struct Kullanici {
        address adres;
        string isim;
        string soyisim;
    }

    //Sabit degiskenler
    address public sahip;
    uint public sonrakiOneriId;
    uint public oneriEsigi;
    uint public kullaniciSayisi;
    uint256 public oneriSayisi = 0;
    
    //Veri kayit yapilari
    mapping(uint => Oneri) public oneriler;
    mapping(address => mapping(uint => bool)) public oylar;
    mapping(address => Kullanici) public kullanicilar;

    //ETH agina bildirim atmak için event'ler
    event OneriOlusturuldu(uint id, string aciklama);
    event OyVerildi(uint oneriId, address oyveren);
    event OneriUygulandi(uint id, string aciklama);
    event KullaniciOlustu(address id, string isim, uint256 date);
   

    // Gerek sartlar icin ozel yapilar
    modifier kullaniciVar(address _id) {
        require(kullanicilar[_id].adres != msg.sender, "Bu kullanici kayitli degil");
        _;
    }

    modifier sadeceSahip() {
        require(msg.sender == sahip, "Bu fonksiyonu sadece sahip kullanabilir");
        _;
    }

    modifier sadeceTekOy(uint oneriId) {
        require(!oylar[msg.sender][oneriId], "Bu oneriye zaten oy verdiniz");
        _;
    }

    //kurucu method
    constructor(uint _oneriEsigi) {
        sahip = msg.sender;
        oneriEsigi = _oneriEsigi;
    }

    //kullaici, gelen kisinin adress degerine göre kayit ediliyor
    function kullaniciEkle(string memory _isim, string memory _soyisim) public {
        kullanicilar[msg.sender] = Kullanici(msg.sender, _isim, _soyisim);

        emit KullaniciOlustu(msg.sender, _isim, block.timestamp);
    }

    // oneri icerik alinarak olusturuluyor
    function oneriOlustur(string memory _aciklama) public sadeceSahip kullaniciVar(msg.sender) {
        oneriler[sonrakiOneriId] = Oneri(sonrakiOneriId, _aciklama, 0, false);
        emit OneriOlusturuldu(sonrakiOneriId, _aciklama);
        sonrakiOneriId++;
        oneriSayisi++;
    }

    //onerilere oy veriliyor
    function oyVer(uint oneriId) public sadeceTekOy(oneriId) kullaniciVar(msg.sender) {
        Oneri storage oneri = oneriler[oneriId];
        require(!oneri.uygulandi, "Oneri zaten uygulandi");

        oneri.oySayisi++;
        oylar[msg.sender][oneriId] = true;
        emit OyVerildi(oneriId, msg.sender);

        if (oneri.oySayisi >= oneriEsigi) {
            oneriUygula(oneriId);
        }
    }

    //oneri oylari esik deger ustunde ise bu method calisiyor
    function oneriUygula(uint oneriId) internal {
        Oneri storage oneri = oneriler[oneriId];
        require(!oneri.uygulandi, "Oneri zaten uygulandi");

        oneri.uygulandi = true;
        emit OneriUygulandi(oneri.id, oneri.aciklama);
        // Oneri spesifik uygulama mantığı buraya eklenebilir
    }

    //id ile oneri getirme methodu
    function oneriGetir(uint oneriId) public view returns (uint, string memory, uint, bool) {
        Oneri storage oneri = oneriler[oneriId];
        return (oneri.id, oneri.aciklama, oneri.oySayisi, oneri.uygulandi);
    }

    // tum onerileri getirme methodu
     function tumOnerileriGetir() public view returns (Oneri[] memory) {
        Oneri[] memory tumOneriler = new Oneri[](oneriSayisi);
        for (uint i = 1; i <= oneriSayisi; i++) {
            tumOneriler[i - 1] = oneriler[i];
        }
        return tumOneriler;
    }
}