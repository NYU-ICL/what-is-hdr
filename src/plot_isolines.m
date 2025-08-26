function plot_isolines( displayNames, displayLuminances, displayContrasts, showIsolines, baseline, baselineName )
    % Inputs: 
    %   displayNames      [string array] - names of displays to plot
    %   displayLuminances [numerical array] - peak luminances of displays to plot
    %   displayContrasts  [numerical array] - contrasts of displays to plot
    %   showIsolines      [boolean array] - whether to plot isolines for a display
    %   baseline          [numerical array] - the [peak luminance, contrast] of a baseline, where JOD is pegged to 0
    %   baselineName      [string] - name of the baseline display

    fontsize = 9;
    xlims = [34, 1140000];
    ylims = [64, 1600];
    numSamples = 500;

    figure('Position', [100, 100, 400*2.2, 400]);

    params = loadModelParams('contentAware'); % load model

    x_range = logspace(log10(xlims(1)), log10(xlims(2)), numSamples);
    y_range = logspace(log10(ylims(1)), log10(ylims(2)), numSamples);
    [X, Y] = meshgrid(x_range, y_range); % heatmap grid

    offset = M(baseline(1)/baseline(2), baseline(1), params); % evaluate baseline
    Z = M(Y./X, Y, params) - offset; % compute model on grid

    % contours
    [C,h] = contourf(X, Y, Z, numSamples, 'LineStyle', 'none');
    colormap(parula(numSamples));
    clabel(C,h,0);

    % create colorbar
    cb = colorbar(); 
    ylabel(cb,'Perceptual Impact [JODs]', 'FontSize', fontsize,'Rotation', 270);
    set(cb);
    cb.LineWidth = .01;
    hold on

    % show isolines
    if ~isempty(displayNames)
        iso = [];
        for i = 1:length(displayNames)
            jodTemp = M(displayLuminances(i)/displayContrasts(i), displayLuminances(i), params);
            iso(end+1) = jodTemp-offset;
        end

        for i = 1:length(iso)
            cm = '-k';
            if showIsolines(i)
                [C,h] = contour(X, Y, Z, [iso(i) iso(i)],cm, 'LineWidth', 1.5);
                h.LevelList = round(h.LevelList, 2);
                clabel(C, h, 'labelspacing', 300, 'FontSize', 8);
                hold on
            end
        end
    end

    % show the baseline display (0 JOD condition)
    scatter(baseline(2), baseline(1), 150, [1, 0, 0], 'x', 'LineWidth', 2.5, 'DisplayName', baselineName);
    hold on

    set(gca,'YScale','log');
    set(gca,'XScale','log');

    % show display scatter points
    if ~isempty(displayNames)
        cs = parula(length(displayNames));
        cs = flip(cs);
        m = 'O';
        for i = 1:length(displayNames)
            c = cs(i,:);
            scatter(displayContrasts(i), displayLuminances(i), 100, c,m,'DisplayName',displayNames{i}, 'MarkerFaceColor', c);
            hold on
        end
    end

    % legend
    unqHandles = legendUnq(gcf);
    hl = legend(unqHandles, 'Location', 'southeast', 'Orientation', 'vertical', 'NumColumns', 1);
    set( hl, 'Color', [0.925, 0.925, 0.925]) ;

    yticks([100, 250, 500, 750, 1000, 1250, 1500]);
    ylabel('Peak Luminance [nits]');
    xlabel('Contrast');
    ax = gca;
    ax.TickLength = [.0, .0];
    set(gca, 'fontsize', fontsize);
    xlim(xlims);
    ylim(ylims);
end

function Z = M( X, Y, params )
    % evaluate model
    Z = (log10(Y).^params.k3).*(params.k1-params.k2.*X.^.5)-params.k4;
end

function data = loadModelParams( tmo )
    % load model parameters
    T = readtable('../data/model_param.csv');
    data = T(strcmp(T.tmo, tmo), :);
end