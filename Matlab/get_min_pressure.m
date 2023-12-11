function min_pressure = get_min_pressure(data)
    data_size = size(data);

    for i = 1:data_size
        data_inner = data{i};

        pressure_1 = data_inner.P1(1:100);
        pressure_2 = data_inner.P2(1:100);
        pressure_3 = data_inner.P3(1:100);
        pressure_4 = data_inner.P4(1:100);
        pressure_5 = data_inner.P5(1:100);
        pressure_6 = data_inner.P6(1:100);
        pressure_7 = data_inner.P7(1:100);

        min_pressure(i) = min(pressure_1) + min(pressure_2) + min(pressure_3) + min(pressure_4) + min(pressure_5) + min(pressure_6) + min(pressure_7);
    end

    min_pressure = min_pressure';
end