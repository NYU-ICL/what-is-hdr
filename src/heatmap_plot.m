% define variables
displayNames = ["Epson 3800 (Home Projector)", "EIZO CG3146 (Reference Monitor)", "VESA DisplayHDR 400", "VESA DisplayHDR 500", "VESA DisplayHDR 600", "VESA DisplayHDR 1000", "VESA DisplayHDR 1400"];
displayLuminances = [258, 1000, 400, 500, 600, 1000, 1400];
displayContrasts = [147, 1000000, 1300, 7000, 8000, 30000, 50000];
showIsolines = [true, false, true, false, true, false, false];
baseline = [100, 64];
baselineName = 'Commercial VR';

plot_isolines(displayNames, displayLuminances, displayContrasts, showIsolines, baseline, baselineName);
