function profile = get_profile (this)
% Function to return all steroid excretion values as a vector
    
    profile = zeros(1,32);
    profile(1) = this.an;
    profile(2) = this.et;
    profile(3) = this.dhea;
    profile(4) = this.x16a_dhea;
    profile(5) = this.x5_pt;
    profile(6) = this.all_5pd;
    profile(7) = this.tha;
    profile(8) = this.x5a_tha;
    profile(9) = this.thb;
    profile(10) = this.x5a_thb;
    profile(11) = this.x3a5b_thaldo;
    profile(12) = this.thdoc;
    profile(13) = this.x5a_thdoc;
    profile(14) = this.pd;
    profile(15) = this.x3a5a_17hp;
    profile(16) = this.x17_hp;
    profile(17) = this.pt;
    profile(18) = this.pt_one;
    profile(19) = this.ths;
    profile(20) = this.f;
    profile(21) = this.x6b_oh_cortisol;
    profile(22) = this.thf;
    profile(23) = this.x5a_thf;
    profile(24) = this.a_cortol;
    profile(25) = this.b_cortol;
    profile(26) = this.x11b_oh_andro;
    profile(27) = this.x11b_oh_etio;                
    profile(28) = this.e;
    profile(29) = this.the;
    profile(30) = this.a_cortolone;
    profile(31) = this.b_cortolone;
    profile(32) = this.x11_oxo_etio;
end
