import matplotlib.pyplot as plt
import numpy as np

def plot_data(vel, temp, label, output):

    """
    Plot the profile of lines
    vel - velocity in cm/s
    temp - main beam temperature in K
    label - describe of data in the legend
    output - name of the picture, which we create
    """
    
    # plot the data
    plt.plot(vel, temp, 'b-', markersize=4.0, label=label)

    # labels
    plt.ylabel('Main beam temperature (K)', fontsize=16)
    plt.xlabel('Velocity (km/s)', fontsize=16)

    # swich off expotential notation
    plt.ticklabel_format(useOffset=False)

    # x limitation of data
    # plt.xlim(JD_start, JD_end)

    # xticks
    # plt.xticks(np.arange(JD_start + 1000, JD_end, 1500))

    # legend
    plt.legend(loc="upper right", fontsize=8)

    # write picture
    plt.savefig(output)

    # close writing picture
    plt.close()
    
def read_and_resolve_profile(input_file, trans_number, how_many):
    
    """
    Read the data and read the data
    input_file - file to read
    trans_number - number of transition with file
    how_many - how many transitons are in the file
    """
    
    factor = 10**5 # change the cm/s for km/s 
    vel_km_s = []  # list of velocities in km/s
    vel_plot = []
    flux_plot = []
    tmb_plot = []
    
    # read the file
    index, vel, flux, tmb = np.genfromtxt(input_file, unpack=True,
              usecols=(0,1,2,3), skip_header=how_many,
               dtype=float)
    
    # convert cm/s for km/s                    
    for i in range(len(vel)):
        vel_km_s.append(vel[i]/factor)
    
    # choose the profile to plot    
    for i in range(len(index)):
        if  index[i] == trans_number:
           vel_plot.append(vel_km_s[i])
           flux_plot.append(flux[i])
           tmb_plot.append(tmb[i])          
     
    return vel_plot, flux_plot, tmb_plot
    
Vel, Flux, Tmb = read_and_resolve_profile("profile.co", 1, 4)
print(Vel)
print(len(Vel))
plot_data(Vel, Tmb, "profile CO 2-1 (model)", "co_2-1.png") 
        
    
    
    
